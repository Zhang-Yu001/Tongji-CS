import pandas as pd
from sklearn.linear_model import LogisticRegression
from xgboost import XGBClassifier
from sklearn.ensemble import VotingClassifier
from sklearn.metrics import roc_auc_score

# 加载数据
X_train = pd.read_csv('./selected_train_features.csv', encoding='utf-8')
y_train = pd.read_csv('./processed_train_master.csv', usecols=['target'], encoding='utf-8')
X_test = pd.read_csv('./selected_test_features.csv', encoding='utf-8')

# 模型融合 - 逻辑回归和XGBoost
lr = LogisticRegression(tol=1e-6, penalty='l1', C=0.1, solver='liblinear')
xgb = XGBClassifier(learning_rate=0.1, max_depth=5, n_estimators=100)
ensemble_model = VotingClassifier(estimators=[('lr', lr), ('xgb', xgb)], voting='soft')
ensemble_model.fit(X_train, y_train.values.ravel())

# 模型评估
y_train_pred = ensemble_model.predict_proba(X_train)[:, 1]
auc_score = roc_auc_score(y_train, y_train_pred)
print(f"Ensemble Model AUC: {auc_score}")

# 预测测试集
test_predictions = ensemble_model.predict_proba(X_test)[:, 1]
result = pd.DataFrame({'ID': pd.read_csv('./processed_test_master.csv', usecols=['Idx']), 'Prediction': test_predictions})
result.to_csv('ensemble_predictions.csv', index=False)
