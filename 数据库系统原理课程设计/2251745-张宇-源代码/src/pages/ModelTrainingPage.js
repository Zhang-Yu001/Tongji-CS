import React, { useState } from 'react';
import ModelSelector from '../components/ModelSelector';
import TrainingStatus from '../components/TrainingStatus';

const ModelTrainingPage = () => {
  const [trainingStarted, setTrainingStarted] = useState(false);

  const startTraining = () => {
    setTrainingStarted(true);
  };

  return (
    <div>
      <h1>模型训练页面</h1>
      <ModelSelector onStartTraining={startTraining} />
      {trainingStarted && <TrainingStatus />}
    </div>
  );
};

export default ModelTrainingPage;
