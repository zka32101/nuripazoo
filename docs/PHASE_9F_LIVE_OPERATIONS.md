# Phase 9F: Live Operations & Content Management

**用途**: 公開後のコンテンツ更新・イベント運営・ユーザー保持の完全ガイド  
**対象**: Product マネージャー・Content チーム・デベロッパー  
**実装時間**: 継続的 (毎月)

---

## 📋 Phase 9F 概要

Phase 9E (Google Play 承認) 後、ぬりパズ動物園 は全世界に公開されます。その後は **持続的なコンテンツ更新** と **ユーザー保持** が成功の鍵となります。

```
Phase 9E: App Store + Google Play 承認済み ✅
    ↓
Phase 9F: Live Operations (継続的)
    ├─ Month 1-2: Pre-launch マーケティング
    ├─ Month 1: 公開リリース + Day 1 Retention 計測
    ├─ Month 2-12: 月次コンテンツ更新 (動物 2-3種)
    ├─ Month 3+: シーズナルイベント・限定動物
    ├─ Ongoing: ユーザーフィードバック収集
    └─ Ongoing: KPI 監視 & チューニング
    ↓
持続的成長 → DAU/MAU 増加 → 収益化
```

---

## 🎯 Phase 9F Success Criteria

✅ **3-6 ヶ月での成功指標**

```
Month 1:
  □ Download: 10,000+ (Day 1)
  □ D1 Retention: ≥65%
  □ Crash-Free: ≥99.5%
  □ Aha Rate: ≥60%

Month 2-3:
  □ MAU: 20,000+
  □ D7 Retention: ≥18%
  □ D30 Retention: ≥8%
  □ Viral Coefficient: ≥0.3

Month 6:
  □ DAU: 5,000+
  □ ARPU: ¥500+ (Monthly)
  □ Viral Coefficient: ≥0.5
  □ Paid Conversion: ≥3%
```

---

## Phase 9F 実装アーキテクチャ

### コンテンツパイプライン

```
コンテンツ企画 (毎月中旬)
  ↓
スプレッドシート管理 (新動物 2-3種)
  ↓
petit_ai 絵柄生成 (または イラストレーター)
  ↓
データ検証スクリプト
  ├─ 重複チェック
  ├─ NGワード確認
  └─ タグ妥当性確認
  ↓
Firestore 投入スクリプト
  ├─ animal_masters コレクション に追加
  └─ Remote Config で フラグ有効化
  ↓
TestFlight 配信 (翌日)
  └─ 内部テスター確認
  ↓
App Store Connect + Google Play Console で更新配信
  └─ 2-3営業日で審査完了・自動リリース
```

### KPI 監視パイプライン

```
毎日 06:00 JST
  ├─ Firebase Analytics > DAU/MAU
  ├─ Crashlytics > Crash-Free Rate
  ├─ aha_moment_reached イベント集計
  └─ Google Analytics 4 レポート生成

毎週 月曜 08:00 JST
  ├─ Weekly Retention (D1/D7/D30)
  ├─ ARPU 計測
  ├─ Viral Coefficient 計算
  └─ 前週比較分析

毎月 月初 09:00 JST
  ├─ 月間 KPI ダッシュボード作成
  ├─ ROI 計算 (広告費 vs 収益)
  ├─ チャーン分析 (なつき度低下率)
  └─ 改善施策の検討会
```

---

## Step 1: 公開リリース準備 (最終 7日)

### リリース前チェックリスト

```
□ 全プラットフォームで App Store / Google Play 承認済み
□ Firebase 本番環境正常動作
□ RevenueCat 本番環境テスト完了
□ Google Mobile Ads 本番環境確認
□ Slack 通知設定 (#release-notifications)
□ PagerDuty ⇔ Slack インテグレーション
□ ユーザーサポート体制構築 (Email, Discord, Twitter)
□ マーケティング素材準備完了
□ プレスリリース配信待機
```

### リリース日程の決定

```
推奨リリース日: 金曜日 18:00 JST
  理由:
    • ウィークエンドでユーザーが遊ぶ時間がある
    • 問題発生時も Saturday チームが対応可能
    • 月曜朝までに問題解決できる

避けるべき日:
    ✗ 月曜日 (Week start のバタバタ)
    ✗ 祝日 (サポートチームが不在)
    ✗ 大型イベント期間 (競合多数)
```

### App Store + Google Play での同時リリース

```
App Store:
  ビルド 1 → Approved ✅
  → リリース実行 (Manual Release)
  → 「Coming Soon」→ 「利用可能」へ移行

Google Play:
  AAB 1 → Approved ✅
  → リリース実行 (100% Rollout)
  → 「プリレジスター」→ 「公開」へ移行

時刻: 同時に実行 (18:00 JST)
  → ユーザーが同時に両ストアでダウンロード可能に
```

---

## Step 2: 月次コンテンツ更新 (毎月 5-7営業日)

### コンテンツ企画フェーズ (毎月中旬)

**新動物 2-3種を決定**

```
スプレッドシート (共有: Product チーム)
  Column A: 動物名 (日本語)
  Column B: 英語名
  Column C: タイプ (陸/水/空/幻)
  Column D: 個性タグ (かわいい, ユニーク, かっこいい, etc)
  Column E: なつき度 Lv1-4 リアクション説明
  Column F: 群れボーナス パターン (R1: 3体で〇〇 演出)
  Column G: イラストレーター指示
  Column H: BGM/SE リファレンス
  Column I: 公開予定日

例:
  キンシコウ | Golden Snub-nosed Monkey | 陸 | 神秘的 | ...
  カタクチイワシ | Japanese Anchovy | 水 | かわいい | ...
```

**petit_ai 自動生成 vs イラストレーター**

```
Option A: petit_ai 絵柄自動生成 (推奨)
  メリット:
    • 月 2-3 種、高速生成可能
    • スタイル統一性高い
    • コスト低い
  
  手順:
    1. 動物の詳細指示を petit_ai に送信
    2. 5-10 パターン生成
    3. Product チームで投票
    4. 選出イメージを微調整
    5. ファイナライズ

Option B: 専属イラストレーター
  メリット:
    • 高い クオリティ・独自性
  
  デメリット:
    • 月 1-2 種に限定
    • コスト高い (¥50-100K/体)
  
推奨ミックス:
  • petit_ai で量を確保 (月 2-3 種)
  • 月 1 回、季節イベント時はイラストレーター起用
```

### データ入力フェーズ (毎月後半)

**Firestore への投入スクリプト**

```bash
# スプレッドシート → CSV エクスポート
# CSV → JSON コンバート
# JSON → Firestore batch write

node scripts/import_animals.js \
  --file data/animals_2026_09.csv \
  --environment production \
  --validate-only  # 最初は検証のみ
```

**検証スクリプト実行**

```javascript
// scripts/validate_animals.js

const validations = [
  {
    name: '重複チェック',
    test: (animals) => {
      const names = animals.map(a => a.name);
      return new Set(names).size === names.length;
    }
  },
  {
    name: 'NGワードチェック',
    test: (animals) => {
      const ngWords = ['クソ', '死ね', '消えろ', /* ... */];
      return !animals.some(a => 
        ngWords.some(w => a.name.includes(w))
      );
    }
  },
  {
    name: 'タグ妥当性',
    test: (animals) => {
      const validTags = ['かわいい', 'ユニーク', 'かっこいい', 'マイペース'];
      return animals.every(a => 
        a.tags.every(t => validTags.includes(t))
      );
    }
  },
  {
    name: 'なつき度リアクション完成',
    test: (animals) => {
      return animals.every(a => a.reactions.lv1 && a.reactions.lv2 && a.reactions.lv3 && a.reactions.lv4);
    }
  }
];

// Run all validations
validations.forEach(v => {
  const result = v.test(animals);
  console.log(`${result ? '✅' : '❌'} ${v.name}`);
});
```

**Firestore へ投入**

```bash
# 検証クリア後に投入
node scripts/import_animals.js \
  --file data/animals_2026_09.csv \
  --environment production \
  --apply  # 実際に投入
```

### TestFlight 配信 (翌営業日)

```bash
# ビルド番号をインクリメント
# 例: 1 → 2

flutter build ios --release --build-number 2

# App Store Connect にアップロード
# (前月の build 1 で App Store に公開中)
# build 2 は TestFlight テスターのみに配信

# 内部テスター (5-10人) に通知
# 確認内容:
#   ✓ 新動物が表示される
#   ✓ なつき度が育成できる
#   ✓ 群れボーナスが出現する
#   ✓ クラッシュなし
```

### App Store / Google Play 配信 (2-3営業日後)

```
App Store Connect:
  → Build 2 を承認
  → 自動リリース (Automatic Release)
  → ユーザーに配信

Google Play Console:
  → Build 2 の新 AAB をアップロード
  → 100% Rollout
  → ユーザーに配信

Timeline:
  Day 1: TestFlight 配信 (内部テスト)
  Day 2-3: 問題なければ App Store 審査
  Day 3-4: Google Play 審査
  Day 5: 両ストアで公開 → ユーザーにOTA更新
```

---

## Step 3: シーズナルイベント & 限定動物

### 季節イベントカレンダー

```
Q1 (Jan-Mar):
  └─ 2月 14日: バレンタイン限定動物 1-2種
     (ハート型・ロマンティックなテーマ)

Q2 (Apr-Jun):
  └─ 5月 5日: こどもの日限定
  └─ 6月: 梅雨限定動物 (水生動物)

Q3 (Jul-Sep):
  └─ 7月 7日: 七夕限定
  └─ 8月 15日: お盆限定
  └─ 9月: 秋の味覚テーマ

Q4 (Oct-Dec):
  └─ 10月 31日: ハロウィン限定 (3-4種)
  └─ 12月 25日: クリスマス限定 (2-3種)
  └─ 12月 31日: 年越し限定
```

### 限定動物の実装

**Remote Config で期間制御**

```javascript
// firebase > Remote Config

{
  "limited_animals": {
    "halloween_2026": {
      "enabled": true,
      "start_date": "2026-10-01T00:00:00Z",
      "end_date": "2026-10-31T23:59:59Z",
      "animal_ids": ["bat_1", "pumpkin_1", "ghost_1", "cat_1"]
    },
    "christmas_2026": {
      "enabled": false,  // 12月になると true に
      "start_date": "2026-12-01T00:00:00Z",
      "end_date": "2026-12-25T23:59:59Z",
      "animal_ids": ["reindeer_1", "snowman_1", "santa_1"]
    }
  }
}
```

**Dart コードでのフロントエンド実装**

```dart
// lib/services/animal_service.dart

Future<List<AnimalMaster>> getLimitedAnimals(DateTime now) async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  
  final limitedAnimalsJson = remoteConfig.getString('limited_animals');
  final limitedAnimals = jsonDecode(limitedAnimalsJson);
  
  List<String> activeAnimalIds = [];
  
  limitedAnimals.forEach((key, config) {
    final startDate = DateTime.parse(config['start_date']);
    final endDate = DateTime.parse(config['end_date']);
    
    if (config['enabled'] && now.isAfter(startDate) && now.isBefore(endDate)) {
      activeAnimalIds.addAll(List<String>.from(config['animal_ids']));
    }
  });
  
  return firestore
    .collection('animal_masters')
    .where(FieldPath.documentId, whereIn: activeAnimalIds)
    .get()
    .then((snapshot) => snapshot.docs.map((doc) => AnimalMaster.fromJson(doc.data())).toList());
}
```

---

## Step 4: KPI 監視と改善ループ

### 毎日計測するメトリクス

```
Firebase Analytics:
  • DAU (Daily Active Users)
  • Session Duration
  • Crash-Free Rate

Firebase Crashlytics:
  • Exception Count
  • Affected Users
  • Top Crashes

Revenue Metrics:
  • Revenue (daily)
  • Paying Users
  • ARPU (Average Revenue Per User)

Engagement:
  • aha_moment_reached (新規ユーザー %)
  • animal_interacted (全体 sessions/day)
  • herd_bonus_unlocked (マイルストーン達成 %)
```

### 毎週レビュー (毎週月曜 08:00)

```markdown
## Weekly KPI Review - Week of {date}

### Retention
- D1: 65% (target: ≥65%) ✅
- D7: 18% (target: ≥18%) ✅
- D30: 8% (target: ≥8%) ✅

### Engagement
- DAU: 5,000 (↑ 500 from last week)
- Sessions/User: 3.2 (↓ -0.1)
- Avg Session Duration: 12 min (↑ +1 min)

### Monetization
- Revenue: ¥50,000 (↑ ¥5,000)
- Paying Users: 150 (↑ 20)
- ARPU: ¥333 (↑ ¥10)

### Issues
- Crash on Android 11+ (affecting 50 users)
  → Fix in progress, ETA EOW

### Actions for Next Week
- [ ] Android crash hotfix deploy
- [ ] A/B test: difficulty adjustment (easy vs normal)
- [ ] Monitor aha_moment_reached (target: 60%)
```

### 毎月戦略会議 (毎月 1日 09:00)

```markdown
## Monthly Strategy Meeting - September 2026

### Overall Performance
- New Installs: 5,000+
- MAU: 20,000
- DAU/MAU Ratio: 25%
- Viral Coefficient: 0.35

### Retention Cohort Analysis
- Day 1: 65% (on-target)
- Day 7: 18% (on-target)
- Day 30: 8% (on-target)
- Churn by Day: Drops at Day 4-5 (affection decay trigger)

### Revenue & ARPU
- Total Revenue: ¥150,000 (Month 1)
- Paying Users: 150 (0.75% conversion)
- ARPU: ¥1,000/user/month
- vs Target: On track

### Viral Growth
- Coefficient: 0.35 (target: ≥0.5)
- Share Created: 500 (Month 1)
- Share → Install: 15% (target: ≥20%)

### Content Performance
- Most Popular Animals: Top 5 list
- Affection Distribution: Modal = Lv 2 (users engaged but not deep)
- Herd Bonus Unlock Rate: 30% (target: ≥40%)

### Problem Areas & Solutions

**Problem 1: Share-to-Install Rate Low (15% vs 20% target)**
  → Solution A: Optimize share screen UX (bigger button)
  → Solution B: Add incentive (share for bonus affection)
  → Action: A/B test in Week 2

**Problem 2: Affection Lv 4 Reach Low (5% vs 10% target)**
  → Solution: Remote Config reduce decay from 3-day to 2-day
  → Action: Deploy in October release

**Problem 3: Churn Spike at Day 4-5**
  → Hypothesis: Affection decay = disengagement
  → Solution: Push notification reminder at Day 3
  → Action: Implement + A/B test

### Planned Updates - October

- New Animals: 2-3 species (petit_ai + 1 illustrator)
- Feature: Push notification reminders
- Event: Halloween limited animals (3-4 species)
- Optimization: Affection decay tuning

### Next Month Target KPIs
- DAU: 6,000+ (↑ 20%)
- D7 Retention: 20% (↑ 2%)
- Revenue: ¥200,000 (↑ 33%)
- Viral Coefficient: 0.45 (↑ 0.1)
```

---

## Step 5: 長期戦略 (6-12 ヶ月)

### User Lifecycle Management

```
Month 1-2: Acquisition Phase
  KPI: Install 10K+, DAU 5K+
  Focus: マーケティング, Press, Social
  Activities:
    • App Store / Google Play feature取得
    • メディア掲載 (AppBank, 4Gamer, etc)
    • Twitter/TikTok キャンペーン
    • YouTube Creator 配信

Month 3-4: Engagement Phase
  KPI: D30 Retention ↑ 8% → 10%
  Focus: コンテンツ拡充, ユーザーフィードバック
  Activities:
    • 月次新動物更新 (3 種/月)
    • シーズナルイベント (Halloween)
    • コミュニティ構築 (Discord)
    • ユーザーガイド・攻略サイト

Month 5-6: Monetization Phase
  KPI: ARPU ¥500+, Paying % 3%+
  Focus: 課金モデル最適化
  Activities:
    • 新しいコスメ・キャラクター追加
    • Battle Pass / Season Pass テスト
    • Limited edition animals (高額課金)
    • VIP tier 検討

Month 6-12: Retention & Growth Loop
  KPI: DAU 継続増, Viral coefficient ≥0.5
  Focus: ユーザー保持と紹介増
  Activities:
    • ソーシャル機能強化
    • ランキング・リーダーボード
    • Guild / Alliance システム
    • Referral program (紹介ボーナス)
```

### Content Roadmap (6-12 ヶ月)

```
Month 1-2: Core Animals (50+ species)
Month 3: Halloween Event (+ 3 limited)
Month 4: Autumn Theme (+ 2-3 species)
Month 5: Winter Prep (+ 2-3 species)
Month 6: Christmas Event (+ 3 limited) + Grand Open (6-month celebration)
Month 7: New Year (+ 2-3 species)
Month 8: Summer Event (+ 3 limited)
Month 9: Anniversary (+ 5 special animals)
Month 10-12: Seasonal + Evergreen content

Total Animals: 150+ species (first year)
Limited Events: 6+ seasonal campaigns
```

---

## ✅ Phase 9F 完了チェックリスト

### リリース準備

```
□ App Store / Google Play 承認済み
□ ユーザーサポート体制構築
□ マーケティング素材完成
□ プレスリリース配信済み
□ SNS / Discord コミュニティ立ち上げ
```

### Month 1 運営

```
□ 公開リリース実行
□ D1 Retention ≥65% 確認
□ Crash-Free ≥99.5% 維持
□ Customer support response time <24h
□ ユーザーフィードバック収集開始
```

### 月次コンテンツ更新

```
□ 新動物 2-3種を毎月追加
□ シーズナルイベント計画・実装
□ Remote Config で期間制御
□ TestFlight で品質確認
□ App Store / Google Play で配信
```

### KPI 監視

```
□ 毎日 KPI ダッシュボード更新
□ 毎週 Retention/Monetization レビュー
□ 毎月 戦略会議実施
□ 四半期ごとに長期目標調整
```

---

## 📊 Success Timeline

```
Month 1: Soft Launch
  Download: 10K+
  DAU: 5K+
  Revenue: ¥100K

Month 3: Early Traction
  MAU: 20K
  D7 Retention: 18%
  Revenue: ¥300K

Month 6: Stable Growth
  DAU: 8K
  Viral Coefficient: 0.4
  Revenue: ¥500K+

Month 12: Mature
  DAU: 10K+
  D30 Retention: 10%+
  Revenue: ¥1M+
  Animals: 150+ species
```

---

## 📞 Key Resources

- **Firebase Console**: https://console.firebase.google.com/
- **App Store Connect**: https://appstoreconnect.apple.com/
- **Google Play Console**: https://play.google.com/console/
- **RevenueCat Dashboard**: https://app.revenuecat.com/
- **Discord Community**: (Community link)
- **Support Email**: support@yourwish.dev

---

## 🚀 Phase 9F の成功へ

```
✅ Release Preparation Complete
  ├─ Phase 9A-9E: 完了
  └─ Phase 9F: 継続的運営へ

🎯 Year 1 Vision:
  • 100K+ ユーザー
  • 150+ 動物キャラクター
  • ¥5M+ revenue
  • 0.5+ viral coefficient

🌟 Long-term Goal:
  ぬりパズ動物園が「毎日触れる愛でるゲーム」として定着
  → コンシューマー向けパズル・カジュアルゲーム市場で
     確立されたIPとなる
```

---

**Version**: 1.0  
**Phase**: 9F Live Operations & Content Management  
**Duration**: Ongoing (12+ months)
