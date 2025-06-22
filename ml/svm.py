import pandas as pd
import numpy as np
from sklearn.svm import SVC
from sklearn.model_selection import cross_val_score
from sklearn.preprocessing import StandardScaler
from scipy.signal import welch
import serial
import joblib
import warnings
import datetime
import time

warnings.filterwarnings("ignore", category=UserWarning)

def train_model():
    # Load data
    df = pd.read_csv('normalized_eeg_stress_dataset.csv')
    X = df[['TP9', 'AF7', 'AF8', 'TP10', 'frontal_asymmetry', 'temporal_asymmetry']]
    y = df['stress_label']

    # Scale features
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)

    # Train SVM with cross-validation
    svm_model = SVC(kernel="linear", C=10, random_state=42, probability=True, gamma=100)

    # Cross-validation
    cv_scores = cross_val_score(svm_model, X_scaled, y, cv=5)
    print(f"Cross-validation scores: {cv_scores}")
    print(f"Mean CV accuracy: {cv_scores.mean():.4f} (+/- {cv_scores.std() * 2:.4f})")

    # Train final model
    svm_model.fit(X_scaled, y)

    # Save model
    joblib.dump(svm_model, "eeg_svm_model.joblib")
    joblib.dump(scaler, "eeg_svm_scaler.joblib")

def upload_stress_probability_to_firestore(stress_probability):
    """
    Uploads the stress probability to Firebase Firestore.

    Args:
        stress_probability (float): The stress probability or percentage to upload.
        timestamp (str): Timestamp string (e.g., ISO format).
        user_id (str): The user identifier.
    """
    import firebase_admin
    from firebase_admin import credentials, firestore

    # Initialize the Firebase app if not already initialized
    if not firebase_admin._apps:
        # Replace 'path/to/serviceAccountKey.json' with your actual service account key file
        cred = credentials.Certificate('gauge-31025-firebase-adminsdk-fbsvc-a559cfbd70.json')
        firebase_admin.initialize_app(cred)

    db = firestore.client()

    data = {
        "timestamp": datetime.datetime.now().astimezone(datetime.timezone.utc),
        "stress": stress_probability,
    }

    try:
        # Add a new document to the 'stress_data' collection
        db.collection('data').add(data)
        print("Stress probability uploaded to Firestore successfully.")
    except Exception as e:
        print(f"Error uploading to Firestore: {e}")

# Function to predict stress percentage from EEG values
def predict_stress_percentage(tp9, af7, af8, tp10, frontal_asymmetry, temporal_asymmetry):
    """
    Predict stress percentage from EEG values.
    
    Args:
        tp9, af7, af8, tp10, frontal_asymmetry, temporal_asymmetry: EEG channel values
        
    Returns:
        float: Stress percentage (0-100)
    """
    # Create array with the 6 features
    sample_data = np.array([[tp9, af7, af8, tp10, frontal_asymmetry, temporal_asymmetry]])
    
    # Scale the data using the same scaler used during training
    sample_scaled = scaler.transform(sample_data)
    
    # Get probability predictions
    probabilities = model.predict_proba(sample_scaled)
    stress_probability = probabilities[0][1]  # Probability of stress class
    
    # Upload to server
    upload_stress_probability_to_firestore(stress_probability * 10)

"""
def cal_power(eeg_value):
    f, psd = welch(eeg_value, fs=256, nperseg=512)
    alpha_power = np.trapz(psd[(f >= 8) & (f <= 12)], f[(f >= 8) & (f <= 12)])
    return alpha_power
"""

def cal_power(eeg_signal, fs=256):
    """
    Calculate band power with proper input validation
    """
    if len(eeg_signal) < 8:  # Minimum samples for meaningful PSD
        return 1e-10  # Return small value to avoid log(0)
    
    # Use nperseg equal to signal length or minimum of 8
    nperseg = min(len(eeg_signal), 8)
    f, psd = welch(eeg_signal, fs=fs, nperseg=nperseg)
    
    # Use trapezoid instead of deprecated trapz
    alpha_power = np.trapezoid(psd[(f >= 8) & (f <= 12)], f[(f >= 8) & (f <= 12)])
    
    # Add small epsilon to avoid zero
    return alpha_power + 1e-10

    
if __name__ == "__main__":
    model = joblib.load("eeg_svm_model.joblib")
    scaler = joblib.load("eeg_svm_scaler.joblib")
    tp9_buffer = []
    af7_buffer = []
    af8_buffer = []
    tp10_buffer = []
    i = 0
    while True:
        ser = serial.Serial('/dev/tty.usbserial-1410', 9600)
        line = ser.readline().decode('utf-8').strip()
        line = [float(x) for x in line.split(",")]
        tp9_buffer.append(line[0])
        af7_buffer.append(line[1])
        af8_buffer.append(line[2])
        tp10_buffer.append(line[3])
        i += 1
        if i > 10:
            fa = np.log(cal_power(af7_buffer)) - np.log(cal_power(af8_buffer))
            ta = np.log(cal_power(tp9_buffer)) - np.log(cal_power(tp10_buffer))
            predict_stress_percentage(line[0], line[1], line[2], line[3], fa, ta)
        time.sleep(1)
