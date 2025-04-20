import os
import json
import sqlite3
from datetime import datetime
from flask import Flask, request, jsonify
from flask_cors import CORS


app = Flask(__name__)
CORS(app)


# Create folders if not exist (Saves the missions here )
MISSIONS_FOLDER = 'missions'
os.makedirs(MISSIONS_FOLDER, exist_ok=True)

# SQLite database setup
DB_PATH = 'hima.db'

def init_db():
    with sqlite3.connect(DB_PATH) as conn:
        c = conn.cursor()
        c.execute('''
            CREATE TABLE IF NOT EXISTS missions (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT,
                timestamp TEXT,
                region_json_path TEXT,
                result_json_path TEXT,
                landmine_count INTEGER,
                FOREIGN KEY (user_id) REFERENCES users(id) 
            )
        ''')
         # Create users table
        c.execute('''
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT UNIQUE NOT NULL,
                password TEXT NOT NULL
            )
        ''')

        conn.commit()

init_db()

# Utility to get mission folder name
def get_mission_folder(mission_id):
    return os.path.join(MISSIONS_FOLDER, f"mission{mission_id}")

# 1. Create a new mission
@app.route('/start-mission', methods=['POST'])
@app.route('/start-mission', methods=['POST'])
def start_mission():
    data = request.get_json()
    timestamp = datetime.utcnow().isoformat()

    with sqlite3.connect(DB_PATH) as conn:
        c = conn.cursor()
        c.execute("INSERT INTO missions (name, timestamp, region_json_path, result_json_path, landmine_count) VALUES (?, ?, ?, ?, ?)",
                  ("", timestamp, "", "", 0))
        mission_id = c.lastrowid

        mission_name = f"Mission {mission_id}"
        folder_path = get_mission_folder(mission_id)
        os.makedirs(folder_path, exist_ok=True)

        region_json_path = os.path.join(folder_path, 'input.json')
        with open(region_json_path, 'w') as f:
            json.dump(data, f, indent=2)

        # Update DB with name + input path
        c.execute("UPDATE missions SET name=?, region_json_path=? WHERE id=?",
                  (mission_name, region_json_path, mission_id))
        conn.commit()

    # --- Call MATLAB script ---
    try:
        subprocess.run(['matlab', '-batch', f"run_simulation({mission_id})"], check=True)
        print("✅ MATLAB simulation executed.")
    except subprocess.CalledProcessError as e:
        print(f"❌ MATLAB failed: {e}")
        return jsonify({"error": "MATLAB simulation failed"}), 500

    # --- Load result.json and update DB ---
    result_path = os.path.join(folder_path, 'result.json')
    if os.path.exists(result_path):
        with open(result_path) as f:
            result_data = json.load(f)
        landmine_count = result_data.get('landmine_count', 0)

        with sqlite3.connect(DB_PATH) as conn:
            c = conn.cursor()
            c.execute("UPDATE missions SET result_json_path=?, landmine_count=? WHERE id=?",
                      (result_path, landmine_count, mission_id))
            conn.commit()
    else:
        return jsonify({"error": "result.json not found"}), 500

    return jsonify({"message": "Mission created and processed", "mission_id": mission_id})

# 2. Upload result.json from MATLAB
@app.route('/upload-result/<int:mission_id>', methods=['POST'])
def upload_result(mission_id):
    data = request.get_json()
    result_path = f"missions/mission{mission_id}/result.json"

    with open(result_path, 'w') as f:
        json.dump(data, f, indent=2)

    # Optional: Read landmine count from result
    landmine_count = data.get("landmine_count", 0)

    with sqlite3.connect(DB_PATH) as conn:
        c = conn.cursor()
        c.execute("UPDATE missions SET result_json_path=?, landmine_count=? WHERE id=?",
                  (result_path, landmine_count, mission_id))
        conn.commit()

    return jsonify({"message": "Result uploaded"})

# 3. Get all missions
@app.route('/missions', methods=['GET'])
def get_all_missions():
    with sqlite3.connect(DB_PATH) as conn:
        c = conn.cursor()
        c.execute("SELECT id, name, timestamp, landmine_count FROM missions")
        missions = [dict(id=row[0], name=row[1], timestamp=row[2], landmine_count=row[3]) for row in c.fetchall()]
    return jsonify(missions)

# 4. Get a specific mission (input + result)
@app.route('/missions/<int:mission_id>', methods=['GET'])
def get_mission_detail(mission_id):
    with sqlite3.connect(DB_PATH) as conn:
        c = conn.cursor()
        c.execute("SELECT * FROM missions WHERE id=?", (mission_id,))
        row = c.fetchone()
        if not row:
            return jsonify({"error": "Mission not found"}), 404

        mission = {
            "id": row[0],
            "name": row[1],
            "timestamp": row[2],
            "region": json.load(open(row[3])) if os.path.exists(row[3]) else None,
            "result": json.load(open(row[4])) if os.path.exists(row[4]) else None,
            "landmine_count": row[5]
        }

    return jsonify(mission)

if __name__ == '__main__':
    app.run(debug=True)
