import pandas as pd
import numpy as np
import joblib
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA

from qiskit.primitives import Sampler
from qiskit_algorithms.state_fidelities import ComputeUncompute
from qiskit.circuit.library import ZZFeatureMap
from qiskit_machine_learning.kernels import FidelityQuantumKernel
from qiskit_machine_learning.algorithms import QSVC

def train_qsvm():
    """
    Trains a Quantum Support Vector Machine (QSVM) on the EEG dataset.
    This function performs the following steps:
    1. Loads the normalized EEG stress dataset.
    2. Scales the data using StandardScaler.
    3. Reduces the feature dimensionality from 6 to 3 using PCA.
    4. Splits the data into training and testing sets.
    5. Defines a quantum kernel using a ZZFeatureMap.
    6. Initializes and trains a QSVC (Quantum Support Vector Classifier).
    7. Saves the trained QSVC model, the scaler, and the PCA transformer.
    """
    print("🚀 Starting QSVM training...")
    print("NOTE: This process can be very slow as it simulates a quantum computer.")

    # 1. Load data
    try:
        df = pd.read_csv('normalized_eeg_stress_dataset.csv')
        X = df[['TP9', 'AF7', 'AF8', 'TP10', 'frontal_asymmetry', 'temporal_asymmetry']]
        y = df['stress_label']
        print("✅ Data loaded successfully.")
    except FileNotFoundError:
        print("❌ Error: 'normalized_eeg_stress_dataset.csv' not found.")
        return

    # 2. Scale features
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)
    print("✅ Features scaled.")

    # 3. Reduce dimensionality with PCA (from 6 to 3 features)
    pca = PCA(n_components=3)
    X_pca = pca.fit_transform(X_scaled)
    print("✅ Dimensionality reduced to 3 features using PCA.")

    # 4. Split data
    X_train, X_test, y_train, y_test = train_test_split(
        X_pca, y, test_size=0.2, random_state=42
    )
    print(f"✅ Data split into {len(X_train)} training and {len(X_test)} testing samples.")

    # 5. Define Quantum Kernel
    print("🤖 Defining Quantum Kernel...")
    feature_map = ZZFeatureMap(feature_dimension=3, reps=2)
    sampler = Sampler()
    fidelity = ComputeUncompute(sampler=sampler)
    quantum_kernel = FidelityQuantumKernel(fidelity=fidelity, feature_map=feature_map)

    # 6. Initialize and Train QSVC
    print("⏳ Training QSVC... This is the slow part. Please be patient.")
    qsvc = QSVC(quantum_kernel=quantum_kernel)
    qsvc.fit(X_train, y_train)
    
    # Evaluate the model
    score = qsvc.score(X_test, y_test)
    print(f"🎉 QSVC training complete! Accuracy on test set: {score:.4f}")

    # 7. Save model and transformers
    print("💾 Saving model, scaler, and PCA transformer...")
    joblib.dump(qsvc, "eeg_qsvm_model.joblib")
    joblib.dump(scaler, "eeg_qsvm_scaler.joblib")
    joblib.dump(pca, "eeg_qsvm_pca.joblib")
    print("✅ All artifacts saved successfully.")


if __name__ == "__main__":
    train_qsvm() 