import pandas as pd
from xgboost import XGBClassifier

# 加载数据
train_master = pd.read_csv('./processed_train_master.csv', encoding='utf-8')
y_train = train_master.pop('target')

# 特征选择 - 基于XGBoost的特征重要性排序
def select_important_features(X, y, top_n=50):
    model = XGBClassifier()
    model.fit(X, y)
    feature_importances = pd.Series(model.feature_importances_, index=X.columns)
    selected_features = feature_importances.nlargest(top_n).index
    return X[selected_features]

X_train_selected = select_important_features(train_master, y_train)
X_train_selected.to_csv('./selected_train_features.csv', index=False, encoding='utf-8')
