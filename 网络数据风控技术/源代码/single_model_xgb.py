import pandas as pd
from xgboost import XGBClassifier
from sklearn.model_selection import GridSearchCV

# 加载数据
X_train = pd.read_csv('./selected_train_features.csv', encoding='utf-8')
y_train = pd.read_csv('./processed_train_master.csv', usecols=['target'], encoding='utf-8')

# XGBoost模型训练与调优
xgb = XGBClassifier()
parameters = {
    'learning_rate': [0.01, 0.1, 0.2],
    'max_depth': [3, 5, 7],
    'n_estimators': [100, 200]
}
clf_xgb = GridSearchCV(xgb, parameters, cv=3, scoring='roc_auc')
clf_xgb.fit(X_train, y_train.values.ravel())

# 输出最佳参数
print(f"Best Params: {clf_xgb.best_params_}")
print(f"Best AUC Score: {clf_xgb.best_score_}")
