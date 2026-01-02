import React, { useState } from 'react';
import { uploadFile } from '../services/api';

const FileUploader = () => {
  const [selectedFile, setSelectedFile] = useState(null);
  const [message, setMessage] = useState('');

  const handleFileChange = (event) => {
    setSelectedFile(event.target.files[0]);
  };

  const handleUpload = async () => {
    if (!selectedFile) {
      setMessage('请选择一个文件进行上传');
      return;
    }

    const formData = new FormData();
    formData.append('file', selectedFile);

    try {
      await uploadFile(formData);
      setMessage('文件上传成功');
    } catch (error) {
      setMessage('文件上传失败，请重试');
    }
  };

  return (
    <div>
      <h3>上传数据文件</h3>
      <input type="file" onChange={handleFileChange} />
      <button onClick={handleUpload}>上传</button>
      <p>{message}</p>
    </div>
  );
};

export default FileUploader;
