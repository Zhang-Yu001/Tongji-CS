from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Mock database
data = [
    {"id": 1, "name": "Data 1", "value": 100},
    {"id": 2, "name": "Data 2", "value": 200},
]
@app.route('/')
def home():
    return "API is running. Use /data or /train endpoints."

# Get all data
@app.route('/data', methods=['GET'])
def get_data():
    return jsonify(data)

# Add new data
@app.route('/data', methods=['POST'])
def add_data():
    new_data = request.json
    new_data['id'] = len(data) + 1
    data.append(new_data)
    return jsonify(new_data), 201

# Update data
@app.route('/data/<int:data_id>', methods=['PUT'])
def update_data(data_id):
    updated_data = request.json
    for item in data:
        if item['id'] == data_id:
            item.update(updated_data)
            return jsonify(item)
    return jsonify({"error": "Data not found"}), 404

# Delete data
@app.route('/data/<int:data_id>', methods=['DELETE'])
def delete_data(data_id):
    global data
    data = [item for item in data if item['id'] != data_id]
    return jsonify({"message": "Deleted"}), 200

# Start training
@app.route('/train', methods=['POST'])
def start_training():
    model = request.json.get('model')
    # Simulate training logic
    return jsonify({"message": f"Training started for model: {model}"}), 200

if __name__ == '__main__':
    app.run(debug=True)
