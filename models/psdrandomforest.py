import pandas as pd
import numpy as np
from scipy.signal import welch
from sklearn.model_selection import train_test_split, cross_val_score, StratifiedKFold
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix
from sklearn.preprocessing import StandardScaler
from sklearn.feature_selection import SelectKBest, f_classif
import matplotlib.pyplot as plt
import seaborn as sns

# Load the dataset
file_path = 'sample_eeg_stress_dataset (1).csv'
data = pd.read_csv(file_path)
data.dropna(inplace=True)

# Define EEG channels and target
eeg_channels = ['TP9', 'AF7', 'AF8', 'TP10', 'frontal_asymmetry', 'temporal_asymmetry']
X_raw = data[eeg_channels]
y = data['stress_label']

# Define EEG frequency bands
bands = {
    'Delta': (0.5, 4),
    'Theta': (4, 8),
    'Alpha': (8, 13),
    'Beta': (13, 30),
    'Gamma': (30, 100)
}
sampling_frequency = 256  # Hz

# Function to extract band power features for a window
def get_band_power(window, sf, bands):
    freqs, psd = welch(window, sf, nperseg=min(256, len(window)))
    features = []
    for band, (low, high) in bands.items():
        mask = (freqs >= low) & (freqs < high)
        if np.any(mask):
            features.append(np.mean(psd[mask]))
        else:
            features.append(0)
    return features

# Create overlapping windows (epochs) with more conservative approach
epoch_len = sampling_frequency  # 1 second
step = epoch_len // 4  # 75% overlap for more data
n_samples = X_raw.shape[0]
n_epochs = (n_samples - epoch_len) // step + 1

X_features = []
y_epochs = []

print(f"Creating {n_epochs} epochs...")

for i in range(n_epochs):
    start = i * step
    end = start + epoch_len
    epoch = X_raw.iloc[start:end]
    if epoch.shape[0] == epoch_len:
        epoch_features = []
        for ch in eeg_channels:
            ch_data = epoch[ch].values
            epoch_features.extend(get_band_power(ch_data, sampling_frequency, bands))
        X_features.append(epoch_features)
        # Use the label at the end of the epoch
        y_epochs.append(y.iloc[end-1])

X_features = np.array(X_features)
y_epochs = np.array(y_epochs)

print(f"Feature matrix shape: {X_features.shape}")
print(f"Class distribution: {np.bincount(y_epochs)}")

# Feature names
feature_names = [f'{ch}_{band}' for ch in eeg_channels for band in bands.keys()]

# Train/test split with stratification
X_train, X_test, y_train, y_test = train_test_split(
    X_features, y_epochs, test_size=0.3, random_state=42, stratify=y_epochs
)

# Scale features
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Feature selection - select top k features
k_best = min(15, X_train_scaled.shape[1])  # Select top 15 features or all if less
selector = SelectKBest(score_func=f_classif, k=k_best)
X_train_selected = selector.fit_transform(X_train_scaled, y_train)
X_test_selected = selector.transform(X_test_scaled)

# Get selected feature names
selected_features = [feature_names[i] for i in selector.get_support(indices=True)]
print(f"\nSelected {len(selected_features)} features:")
for i, feature in enumerate(selected_features):
    print(f"{i+1}. {feature}")

# Train Random Forest with cross-validation
rf = RandomForestClassifier(n_estimators=100, random_state=42, max_depth=10)

# Cross-validation
cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)
cv_scores = cross_val_score(rf, X_train_selected, y_train, cv=cv, scoring='accuracy')
print(f"\nCross-validation scores: {cv_scores}")
print(f"Mean CV accuracy: {cv_scores.mean():.4f} (+/- {cv_scores.std() * 2:.4f})")

# Train final model
rf.fit(X_train_selected, y_train)

# Predict and evaluate
y_pred = rf.predict(X_test_selected)
accuracy = accuracy_score(y_test, y_pred)
print(f'\nTest accuracy: {accuracy:.4f}')

# # Detailed classification report
# print('\nClassification Report:')
# print(classification_report(y_test, y_pred, target_names=['No Stress', 'Stress']))

# # Confusion matrix
# cm = confusion_matrix(y_test, y_pred)
# plt.figure(figsize=(8, 6))
# sns.heatmap(cm, annot=True, fmt='d', cmap='Blues', 
#             xticklabels=['No Stress', 'Stress'],
#             yticklabels=['No Stress', 'Stress'])
# plt.title('Confusion Matrix')
# plt.ylabel('True Label')
# plt.xlabel('Predicted Label')
# plt.tight_layout()
# plt.savefig('psd_rf_confusion_matrix.png', dpi=300)
# plt.show()

# # Feature importances for selected features
# importances = rf.feature_importances_
# importance_df = pd.DataFrame({
#     'feature': selected_features, 
#     'importance': importances
# })
# importance_df = importance_df.sort_values(by='importance', ascending=False)

# print('\nFeature Importances:')
# print(importance_df)

# # Plot feature importances
# plt.figure(figsize=(12, 8))
# plt.bar(range(len(importance_df)), importance_df['importance'])
# plt.xticks(range(len(importance_df)), importance_df['feature'], rotation=45, ha='right')
# plt.title('PSD Feature Importances (Selected Features)')
# plt.ylabel('Importance')
# plt.tight_layout()
# plt.savefig('psd_rf_improved_importances.png', dpi=300)
# plt.show()

# # Additional analysis: Band-wise importance
# band_importance = {}
# for feature, importance in zip(selected_features, importances):
#     band = feature.split('_')[-1
#     if band not in band_importance:
#         band_importance[band] = []
#     band_importance[band].append(importance)

# print('\nBand-wise Average Importance:')
# for band, importances_list in band_importance.items():
#     avg_importance = np.mean(importances_list)
#     print(f"{band}: {avg_importance:.4f}")

# # Channel-wise importance
# channel_importance = {}
# for feature, importance in zip(selected_features, importances):
#     channel = '_'.join(feature.split('_')[:-1])
#     if channel not in channel_importance:
#         channel_importance[channel] = []
#     channel_importance[channel].append(importance)

# print('\nChannel-wise Average Importance:')
# for channel, importances_list in channel_importance.items():
#     avg_importance = np.mean(importances_list)
#     print(f"{channel}: {avg_importance:.4f}") 