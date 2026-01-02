import React, { useState } from 'react';
import { deleteData } from '../services/api';

const DataRemover = ({ dataId, onRemoveComplete }) => {
  const [message, setMessage] = useState('');

  const handleDelete = async () => {
    try {
      await deleteData(dataId);
      setMessage('数据删除成功');
      onRemoveComplete(); // 通知父组件刷新数据
    } catch (error) {
      setMessage('数据删除失败，请重试');
    }
  };

  return (
    <div>
      <p>确认删除此数据？</p>
      <button onClick={handleDelete}>确认</button>
      <p>{message}</p>
    </div>
  );
};

export default DataRemover;
