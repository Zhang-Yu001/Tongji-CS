import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import GridSearchCV

# 加载数据
X_train = pd.read_csv('./selected_train_features.csv', encoding='utf-8')
y_train = pd.read_csv('./processed_train_master.csv', usecols=['target'], encoding='utf-8')

# 逻辑回归模型训练与调优
parameters = {'penalty': ('l1', 'l2'), 'C': [0.01, 0.1, 1, 10, 100]}
lr = LogisticRegression(tol=1e-6, solver='liblinear')
clf_lr = GridSearchCV(lr, parameters, cv=3, scoring='roc_auc')
clf_lr.fit(X_train, y_train.values.ravel())

# 输出最佳参数
print(f"Best Params: {clf_lr.best_params_}")
print(f"Best AUC Score: {clf_lr.best_score_}")
