import torch
from src.models.yolo import YOLO
from src.models.ssd import SSD
from src.data.load_data import load_data
from src.data.preprocess import preprocess_data
from src.training.utils import train_model

def main():
    # Load and preprocess data
    data = load_data('data/raw')
    processed_data = preprocess_data(data)
    
    # Choose the model
    model = YOLO()  # or SSD()
    
    # Train the model
    train_model(model, processed_data)

if __name__ == "__main__":
    main()
