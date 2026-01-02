import axios from 'axios';

const API_BASE = 'http://localhost:5000';

export const uploadFile = (formData) => axios.post(`${API_BASE}/upload`, formData);

export const editData = (id, data) => axios.put(`${API_BASE}/data/${id}`, data);

export const deleteData = (id) => axios.delete(`${API_BASE}/data/${id}`);

export const fetchTrainingLogs = () => axios.get(`${API_BASE}/training/logs`);
