import os
import json
import argparse
import sys
import numpy as np
from pathlib import Path
from sklearn.model_selection import train_test_split

# Allow import of data_loader from same directory
sys.path.insert(0, str(Path(__file__).resolve().parent))
from data_loader import load_rosetta_stone


class _NumpyEncoder(json.JSONEncoder):
    """Handle numpy types from pandas .to_dict()."""
    def default(self, obj):
        if isinstance(obj, np.integer):
            return int(obj)
        if isinstance(obj, np.floating):
            return float(obj)
        if isinstance(obj, np.ndarray):
            return obj.tolist()
        return super().default(obj)


def save_split(dataset, output_path):
    # Convert dataset to list of dicts for saving
    data_list = list(dataset)
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(data_list, f, ensure_ascii=False, cls=_NumpyEncoder)
    print(f"Saved {len(data_list)} items to {output_path}")

def main():
    parser = argparse.ArgumentParser(description="Prepare data for translation training")
    parser.add_argument("--pairs_dir", type=str, default="rosetta_stone/pairs", help="Directory containing Rosetta Stone pairs")
    parser.add_argument("--pipeline_data_dir", type=str, default="training_data", help="Directory containing pipeline training data")
    parser.add_argument("--output_dir", type=str, default="training/data", help="Output directory for splits")
    parser.add_argument("--seed", type=int, default=42, help="Random seed")
    args = parser.parse_args()

    # Create output directory
    os.makedirs(args.output_dir, exist_ok=True)

    print(f"Loading data from {args.pairs_dir}...")
    # Load Rosetta Stone data
    rs_dataset = load_rosetta_stone(args.pairs_dir)
    print(f"Loaded {len(rs_dataset)} pairs from Rosetta Stone.")

    # Load pipeline data if available
    pipeline_dataset = None
    if os.path.exists(args.pipeline_data_dir):
        # Assuming same format, we can try to reuse load_rosetta_stone or similar logic
        # For now, let's try loading it as if it's rosetta stone format
        # If the format is different, we might need adjustments.
        # But given the instructions, it implies they are pairs suitable for training.
        try:
            pipeline_dataset = load_rosetta_stone(args.pipeline_data_dir)
            print(f"Loaded {len(pipeline_dataset)} pairs from pipeline data.")
        except Exception as e:
            print(f"Failed to load pipeline data: {e}")
            pipeline_dataset = []
    
    # Convert to pandas/list for splitting
    # We need 'complexity' for stratification
    
    # Filter out entries without complexity if necessary, or fill defaults
    # load_rosetta_stone fills "moderate" as default
    
    data = rs_dataset.to_pandas()
    
    # Check if we have enough data to split
    if len(data) == 0:
        print("No data found!")
        return

    # Stratified split
    # Train: 90%, Val: 5%, Test: 5%
    # First split: Train (90%) vs Temp (10%)
    
    # We handle small classes in complexity
    # If a complexity class has too few members, we might not be able to stratify strictly.
    # Let's fallback to random split if stratification fails?
    # Or just warn.
    
    try:
        train_df, temp_df = train_test_split(
            data, 
            test_size=0.10, 
            stratify=data["complexity"], 
            random_state=args.seed
        )
        
        val_df, test_df = train_test_split(
            temp_df,
            test_size=0.50, # 50% of 10% = 5%
            stratify=temp_df["complexity"],
            random_state=args.seed
        )
    except ValueError as e:
        print(f"Warning: Stratified split failed (likely due to rare classes). Falling back to random split. Error: {e}")
        train_df, temp_df = train_test_split(
            data, 
            test_size=0.10, 
            random_state=args.seed
        )
        val_df, test_df = train_test_split(
            temp_df,
            test_size=0.50,
            random_state=args.seed
        )

    # Convert back to list/dict
    train_data = train_df.to_dict(orient="records")
    val_data = val_df.to_dict(orient="records")
    test_data = test_df.to_dict(orient="records")
    
    # Add pipeline data to train
    if pipeline_dataset and len(pipeline_dataset) > 0:
        pipeline_list = pipeline_dataset.to_list()
        print(f"Adding {len(pipeline_list)} pipeline pairs to train set.")
        train_data.extend(pipeline_list)
        
    print(f"Split sizes:")
    print(f"  Train: {len(train_data)}")
    print(f"  Val:   {len(val_data)}")
    print(f"  Test:  {len(test_data)}")
    
    # Save files
    save_split(train_data, os.path.join(args.output_dir, "train.json"))
    save_split(val_data, os.path.join(args.output_dir, "val.json"))
    save_split(test_data, os.path.join(args.output_dir, "test.json"))

if __name__ == "__main__":
    main()
