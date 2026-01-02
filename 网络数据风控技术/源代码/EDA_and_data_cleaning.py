import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# 数据路径
dataset_path = r'riskcontrol9297'

# 加载数据
train_master = pd.read_csv(os.path.join(dataset_path, 'Master_Training_Set.csv'), encoding='gbk')
train_userupdateinfo = pd.read_csv(os.path.join(dataset_path, 'Userupdate_Info_Training_Set.csv'), encoding='gbk')
train_loginfo = pd.read_csv(os.path.join(dataset_path, 'LogInfo_Training_Set.csv'), encoding='gbk')
test_master = pd.read_csv(os.path.join(dataset_path, 'Master_Test_Set.csv'), encoding='gbk')
test_userupdateinfo = pd.read_csv(os.path.join(dataset_path, 'Userupdate_Info_Test_Set.csv'), encoding='gbk')
test_loginfo = pd.read_csv(os.path.join(dataset_path, 'LogInfo_Test_Set.csv'), encoding='gbk')

# 数据清洗 - 缺失值处理
def process_missing_values(df):
    df.drop(['WeblogInfo_1', 'WeblogInfo_3'], axis=1, inplace=True)  # 删除高缺失率列
    # 用均值或众数填充缺失值
    numeric_cols = df.select_dtypes(include=[np.number])
    categoric_cols = df.select_dtypes(include=['object'])
    
    for col in numeric_cols.columns:
        df[col].fillna(df[col].mean(), inplace=True)
    
    for col in categoric_cols.columns:
        df[col].fillna(df[col].mode()[0], inplace=True)

# 处理训练集和测试集的缺失值
process_missing_values(train_master)
process_missing_values(test_master)

# 异常值处理 - 剔除标准差接近零的特征
def remove_low_variance_features(df, threshold=0.01):
    numeric_columns = df.select_dtypes(include=[np.number])
    low_variance_cols = numeric_columns.std()[numeric_columns.std() < threshold].index
    df.drop(columns=low_variance_cols, inplace=True)

remove_low_variance_features(train_master)
remove_low_variance_features(test_master)

# 保存清洗后的数据
train_master.to_csv('./cleaned_train_master.csv', index=False, encoding='utf-8')
test_master.to_csv('./cleaned_test_master.csv', index=False, encoding='utf-8')
