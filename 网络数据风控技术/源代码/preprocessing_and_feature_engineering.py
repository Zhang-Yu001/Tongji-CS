import pandas as pd
import numpy as np
import re
from sklearn.preprocessing import OneHotEncoder

# 加载数据
train_master = pd.read_csv('./cleaned_train_master.csv', encoding='utf-8')
test_master = pd.read_csv('./cleaned_test_master.csv', encoding='utf-8')

# 文本处理
def text_preprocessing(df):
    df['UserInfo_9'] = df['UserInfo_9'].str.strip()  # 去掉空格
    df['UserInfo_8'] = df['UserInfo_8'].apply(lambda x: re.sub(r'市$', '', x))  # 去掉"市"字

text_preprocessing(train_master)
text_preprocessing(test_master)

# 地理位置信息处理 - 省份特征提取
def add_geolocation_features(df):
    df['is_high_risk_province'] = df['UserInfo_7'].apply(lambda x: 1 if x in ['四川', '湖南', '湖北'] else 0)
    df['city_level'] = df['UserInfo_8'].apply(lambda x: 1 if x in ['北京', '上海', '广州', '深圳'] else 3)

add_geolocation_features(train_master)
add_geolocation_features(test_master)

# 成交时间离散化
train_master['transaction_month'] = pd.to_datetime(train_master['ListingInfo']).dt.month
train_master['transaction_day'] = pd.to_datetime(train_master['ListingInfo']).dt.day
test_master['transaction_month'] = pd.to_datetime(test_master['ListingInfo']).dt.month
test_master['transaction_day'] = pd.to_datetime(test_master['ListingInfo']).dt.day

# 保存特征工程后的数据
train_master.to_csv('./processed_train_master.csv', index=False, encoding='utf-8')
test_master.to_csv('./processed_test_master.csv', index=False, encoding='utf-8')
