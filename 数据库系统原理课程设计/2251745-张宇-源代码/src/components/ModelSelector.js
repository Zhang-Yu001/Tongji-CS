import React from "react";

export default function ModelSelector({ selectedModel, onModelChange, onStartTraining }) {
  return (
    <div>
      <h3>Model Selection</h3>
      <select
        value={selectedModel}
        onChange={(e) => onModelChange(e.target.value)}
      >
        <option value="">Select Model</option>
        <option value="Diffusion Model">Diffusion Model</option>
        <option value="Transformer">Transformer</option>
      </select>
      <button onClick={onStartTraining}>Start Training</button>
    </div>
  );
}
