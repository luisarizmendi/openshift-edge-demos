from flask import Flask, request, jsonify, send_from_directory, render_template_string
import os
import logging

app = Flask(__name__)

# Set up logging to output errors to the console
logging.basicConfig(level=logging.DEBUG)

# Ensure the upload directory exists
UPLOAD_FOLDER = 'uploads'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route('/')
def home():
    files = os.listdir(app.config['UPLOAD_FOLDER'])
    file_links = ''.join(
        f'<li><span class="file-name">{file}</span> '
        f'<div class="button-group"><a href="/download/{file}" class="btn btn-download">Download</a> '
        f'<a href="#" class="btn btn-delete" onclick="deleteFile(\'{file}\')">Delete</a></div></li>' 
        for file in files if os.path.isfile(os.path.join(app.config['UPLOAD_FOLDER'], file))
    )
    return render_template_string('''
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>File Upload</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background-color: #f4f4f9;
                    margin: 0;
                    padding: 20px;
                    color: #333;
                }
                h1, h2 {
                    color: #444;
                }
                .container {
                    max-width: 800px;
                    margin: 0 auto;
                    background-color: white;
                    padding: 20px;
                    border-radius: 8px;
                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                }
                form {
                    margin-bottom: 20px;
                }
                input[type="file"] {
                    padding: 10px;
                    border: 1px solid #ddd;
                    border-radius: 4px;
                    display: block;
                    margin-bottom: 10px;
                    width: 100%;
                }
                input[type="submit"] {
                    background-color: #28a745;
                    color: white;
                    padding: 10px 20px;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    font-size: 16px;
                }
                input[type="submit"]:hover {
                    background-color: #218838;
                }
                ul {
                    list-style: none;
                    padding: 0;
                }
                li {
                    background-color: #f9f9f9;
                    padding: 10px;
                    margin-bottom: 10px;
                    border: 1px solid #ddd;
                    border-radius: 4px;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }
                li .file-name {
                    flex-grow: 1;
                }
                .btn {
                    text-decoration: none;
                    padding: 5px 10px;
                    border-radius: 4px;
                    font-size: 14px;
                }
                .btn-download {
                    background-color: #007bff;
                    color: white;
                    margin-right: 10px;
                }
                .btn-download:hover {
                    background-color: #0056b3;
                }
                .btn-delete {
                    background-color: #dc3545;
                    color: white;
                }
                .btn-delete:hover {
                    background-color: #c82333;
                }
                .button-group {
                    display: flex;
                    justify-content: flex-end;
                    align-items: center;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>Upload File</h1>
                <form id="uploadForm" action="/upload" method="post" enctype="multipart/form-data">
                    <input type="file" name="file" required>
                    <input type="submit" value="Upload">
                </form>
                <h2>Uploaded Files</h2>
                <ul>
                    {{ file_links|safe }}
                </ul>
            </div>
            <script>
                document.getElementById('uploadForm').onsubmit = function(event) {
                    event.preventDefault(); // Prevent default form submission
                    var formData = new FormData(this);
                    fetch(this.action, {
                        method: 'POST',
                        body: formData
                    })
                    .then(response => {
                        if (response.ok) {
                            return response.json();
                        }
                        throw new Error('Upload failed');
                    })
                    .then(data => {
                        alert('File uploaded successfully: ' + data.success);
                        location.reload(); // Reload the page to update the file list
                    })
                    .catch(error => {
                        alert('Error: ' + error.message);
                    });
                };

                function deleteFile(filename) {
                    if (confirm('Are you sure you want to delete ' + filename + '?')) {
                        fetch('/delete/' + filename, {
                            method: 'DELETE'
                        })
                        .then(response => {
                            if (response.ok) {
                                alert('File deleted successfully.');
                                location.reload();
                            } else {
                                alert('Failed to delete the file.');
                            }
                        });
                    }
                }
            </script>
        </body>
        </html>
    ''', file_links=file_links)

@app.route('/upload', methods=['POST'])
def upload_file():
    try:
        if 'file' not in request.files:
            logging.error('No file part')
            return jsonify({'error': 'No file part'}), 400
        
        file = request.files['file']
        if file.filename == '':
            logging.error('No selected file')
            return jsonify({'error': 'No selected file'}), 400

        # Check if the file already exists
        file_path = os.path.join(app.config['UPLOAD_FOLDER'], file.filename)
        if os.path.exists(file_path):
            logging.error('File already exists')
            return jsonify({'error': 'File already exists'}), 400

        # Save the file
        file.save(file_path)
        logging.info(f'File saved to {file_path}')
        return jsonify({'success': 'File uploaded successfully'}), 201

    except Exception as e:
        logging.error(f'Error occurred: {e}')
        return jsonify({'error': 'Internal Server Error'}), 500

@app.route('/download/<filename>', methods=['GET'])
def download_file(filename):
    try:
        return send_from_directory(app.config['UPLOAD_FOLDER'], filename, as_attachment=True)
    except Exception as e:
        logging.error(f'Error occurred while downloading {filename}: {e}')
        return jsonify({'error': 'File not found'}), 404

@app.route('/delete/<filename>', methods=['DELETE'])
def delete_file(filename):
    try:
        file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        if os.path.isfile(file_path):
            os.remove(file_path)
            logging.info(f'File {filename} deleted successfully')
            return jsonify({'success': f'File {filename} deleted successfully'}), 200
        else:
            logging.error(f'File {filename} not found')
            return jsonify({'error': 'File not found'}), 404
    except Exception as e:
        logging.error(f'Error occurred while deleting {filename}: {e}')
        return jsonify({'error': 'Internal Server Error'}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
