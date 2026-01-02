import React, { useState, useEffect } from "react";
import DataTable from "../components/DataTable";
import ModelSelector from "../components/ModelSelector";
import TrainingStatus from "../components/TrainingStatus";
import { fetchData, addData, updateData, deleteData, startTraining } from "../services/api";

export default function Dashboard() {
  const [data, setData] = useState([]);
  const [selectedModel, setSelectedModel] = useState("");

  useEffect(() => {
    loadData();
  }, []);

  const loadData = async () => {
    const result = await fetchData();
    setData(result);
  };

  return (
    <div style={{ display: "flex", padding: "20px" }}>
      <div style={{ flex: 1, marginRight: "20px" }}>
        <DataTable
          data={data}
          onAdd={async (newData) => {
            await addData(newData);
            loadData();
          }}
          onUpdate={async (id, value) => {
            await updateData(id, value);
            loadData();
          }}
          onDelete={async (id) => {
            await deleteData(id);
            loadData();
          }}
        />
      </div>
      <div style={{ flex: 1, marginRight: "20px" }}>
        <ModelSelector
          selectedModel={selectedModel}
          onModelChange={setSelectedModel}
          onStartTraining={async () => {
            await startTraining(selectedModel);
            alert(`Training started with model: ${selectedModel}`);
          }}
        />
      </div>
      <div style={{ flex: 1 }}>
        <TrainingStatus />
      </div>
    </div>
  );
}
