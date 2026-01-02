import React, { useState } from 'react';
import { editData } from '../services/api';

const DataEditor = ({ data, onEditComplete }) => {
  const [formData, setFormData] = useState(data);
  const [message, setMessage] = useState('');

  const handleChange = (event) => {
    const { name, value } = event.target;
    setFormData({ ...formData, [name]: value });
  };

  const handleSubmit = async () => {
    try {
      await editData(formData.id, formData);
      setMessage('数据修改成功');
      onEditComplete(); // 通知父组件刷新数据
    } catch (error) {
      setMessage('数据修改失败，请重试');
    }
  };

  return (
    <div>
      <h3>编辑数据</h3>
      {Object.keys(formData).map((key) => (
        <div key={key}>
          <label>{key}</label>
          <input
            name={key}
            value={formData[key]}
            onChange={handleChange}
          />
        </div>
      ))}
      <button onClick={handleSubmit}>保存</button>
      <p>{message}</p>
    </div>
  );
};

export default DataEditor;
