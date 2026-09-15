# Phase 10: Post-Launch Analytics & Optimization

**用途**: 公開後のデータ分析・ユーザー行動最適化・成長加速の完全ガイド  
**対象**: Data Analyst・Product マネージャー・Growth Engineer  
**実装時間**: 継続的 (公開から 6-12 ヶ月)

---

## 📋 Phase 10 概要

Phase 9F (Live Operations) で公開・月次更新を開始した後、Phase 10 では **ユーザー行動データの深堀り分析** と **段階的な最適化施策** を実行します。

```
Phase 9F: 公開リリース + 月次更新 ✅
    ↓
Phase 10: Post-Launch Analytics & Growth
    ├─ Month 1: 基礎データ収集・ダッシュボード構築
    ├─ Month 2-3: ユーザー行動分析・チャーン因子特定
    ├─ Month 4-6: A/B テスト・施策検証・最適化
    ├─ Month 6-9: スケーリング・新機能検討
    └─ Month 9-12: 長期戦略・年次計画
    ↓
継続的成長 → DAU↑ / Retention↑ / Revenue↑
```

---

## 🎯 Phase 10 Success Criteria

✅ **6-12 ヶ月での成功指標**

```
Month 1-2: Data Foundation
  □ Analytics ダッシュボード構築完了
  □ Cohort 分析で Retention パターン可視化
  □ Churn 因子を 3+ 特定
  □ KPI 監視自動化

Month 3-4: Optimization
  □ A/B テスト 5+ 実施
  □ Aha Moment より前の drop-off 30%+ 削減
  □ D7 Retention 18% → 20%+
  □ ARPU 10%+ 向上

Month 5-6: Growth
  □ Viral Coefficient 0.35 → 0.5+
  □ DAU 5K → 8K+ (60% growth)
  □ New Installs from organic 50%+
  □ Revenue trending 2x from Month 1

Month 9-12: Scaling
  □ DAU 10K+
  □ D30 Retention 10%+ (initial 8%)
  □ Revenue ¥5M+ (annualized)
  □ International expansion 20%+
```

---

## Step 1: Analytics 基盤構築 (Month 1)

### Google Analytics 4 セットアップ

**GA4 プロパティ作成**

```
Google Analytics 4 Console
  → 新しいプロパティ作成
    Property Name: ぬりパズ動物園 (iOS + Android)
    Industry: Games
    Business Objective: Revenue
    Location: Japan
```

**Dart SDK 統合**

```dart
// lib/services/analytics_service.dart

import 'package:google_analytics_flutter/google_analytics_flutter.dart';
import 'firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final _instance = AnalyticsService._();
  final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics.instance;
  
  factory AnalyticsService() => _instance;
  AnalyticsService._();

  // Standard Events
  Future<void> logScreenView(String screenName) async {
    await _firebaseAnalytics.logScreenView(
      screenName: screenName,
      screenClass: screenName,
    );
  }

  Future<void> logPuzzleCompleted(String animalId, int difficulty) async {
    await _firebaseAnalytics.logEvent(
      name: 'puzzle_completed',
      parameters: {
        'animal_id': animalId,
        'difficulty': difficulty,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logAffectionInteraction(String animalId, int affectionLevel) async {
    await _firebaseAnalytics.logEvent(
      name: 'animal_interacted',
      parameters: {
        'animal_id': animalId,
        'affection_level': affectionLevel,
      },
    );
    
    // Aha moment check
    if (affectionLevel >= 1) {
      await _firebaseAnalytics.logEvent(
        name: 'aha_moment_reached',
        parameters: {
          'first_interaction': true,
          'animal_id': animalId,
        },
      );
    }
  }

  Future<void> logHerdBonusUnlocked(String herdsType) async {
    await _firebaseAnalytics.logEvent(
      name: 'herd_bonus_unlocked',
      parameters: {
        'herd_type': herdsType,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logShare(String shareMethod) async {
    await _firebaseAnalytics.logEvent(
      name: 'share_created',
      parameters: {
        'share_method': shareMethod, // 'twitter', 'line', 'instagram', etc
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logPaymentInitiated(String productId, double price) async {
    await _firebaseAnalytics.logBeginCheckout(
      value: price,
      currency: 'JPY',
      items: [
        AnalyticsEventItem(
          itemId: productId,
          itemName: productId,
          price: price,
        )
      ],
    );
  }

  Future<void> logPaymentCompleted(String productId, double price) async {
    await _firebaseAnalytics.logPurchase(
      value: price,
      currency: 'JPY',
      items: [
        AnalyticsEventItem(
          itemId: productId,
          itemName: productId,
          price: price,
        )
      ],
    );
  }
}
```

### Firestore での詳細ログ記録

```javascript
// Cloud Function: logUserEvent

exports.logUserEvent = functions.https.onCall(async (data, context) => {
  const { userId, eventType, eventData } = data;
  
  const eventDoc = {
    userId,
    eventType,
    eventData,
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
    deviceInfo: {
      os: data.os, // 'iOS' or 'Android'
      version: data.appVersion,
      locale: data.locale,
    },
    sessionId: data.sessionId,
  };

  // Firestore に記録
  await admin.firestore()
    .collection('user_events')
    .doc(`${userId}_${Date.now()}`)
    .set(eventDoc);

  // BigQuery への自動エクスポート (Firebase 設定済)
  return { success: true };
});
```

### Firebase BigQuery 統合

```
Firebase Console > Firestore > BigQuery Export
  → user_events コレクション を毎日エクスポート
  → BigQuery テーブル: nuripazu.user_events_raw
```

### Google Analytics 4 ダッシュボード作成

**必須ダッシュボード**

```
1️⃣ User Acquisition Dashboard
   └─ Traffic sources (Organic, Paid, Direct, Referral)
   └─ New Users by Country
   └─ Install source tracking
   └─ Cost per Install (if paid)

2️⃣ Engagement Dashboard
   └─ DAU / MAU / WAU
   └─ Session Duration
   └─ Screen flow analysis
   └─ Event frequency

3️⃣ Retention Dashboard
   └─ Retention Cohorts (D1, D7, D30)
   └─ Churn rate by cohort
   └─ Retention by user segment
   └─ Time to Churn distribution

4️⃣ Monetization Dashboard
   └─ Revenue by source
   └─ ARPU / ARPPU
   └─ Paying user % (conversion)
   └─ LTV (Lifetime Value)
   └─ Purchase frequency

5️⃣ Quality Dashboard
   └─ Crash-Free Rate
   └─ ANR (Application Not Responding)
   └─ Slowness %
   └─ Error rate by type
```

---

## Step 2: ユーザー行動分析 (Month 2-3)

### Cohort Analysis

**定義: Cohort**

```
Cohort = 同じ時期にアプリをインストールしたユーザー群

例:
  Cohort Week 1 (Sep 1-7): 1,000 users
    → Week 1 Retention (D1): 65%
    → Week 2 Retention (D7): 18%
    → Week 3 Retention (D30): 8%
    
  Cohort Week 2 (Sep 8-14): 1,200 users
    → Week 1 Retention (D1): 66%
    → Week 2 Retention (D7): 19%
    → Week 3 Retention (D30): 9%
    (Month 1 より改善 → 新動物・最適化の効果)
```

**SQL: Cohort Analysis (BigQuery)**

```sql
-- BigQuery: nuripazu.user_events_raw

WITH user_cohorts AS (
  SELECT
    userId,
    DATE_TRUNC(TIMESTAMP(eventData.installDate), WEEK) as install_cohort,
    ROW_NUMBER() OVER (PARTITION BY userId ORDER BY timestamp) as event_rank,
  FROM `nuripazu.user_events_raw`
  WHERE eventType = 'app_launched'
)

SELECT
  install_cohort,
  COUNT(DISTINCT userId) as total_users,
  COUNTIF(event_rank = 1) as d1_retained,
  COUNTIF(event_rank >= 7) as d7_retained,
  COUNTIF(event_rank >= 30) as d30_retained,
  ROUND(COUNTIF(event_rank = 1) / COUNT(DISTINCT userId) * 100, 1) as d1_retention_pct,
  ROUND(COUNTIF(event_rank >= 7) / COUNT(DISTINCT userId) * 100, 1) as d7_retention_pct,
  ROUND(COUNTIF(event_rank >= 30) / COUNT(DISTINCT userId) * 100, 1) as d30_retention_pct,
FROM user_cohorts
GROUP BY install_cohort
ORDER BY install_cohort DESC;
```

### Funnel Analysis

**目的: ユーザーが最初に落ちる場所を特定**

```
Funnel: App Launch → Onboarding → First Puzzle → Completion → Aha Moment

Step 1: app_launched
  100% (5,000 users)

Step 2: onboarding_started
  95% (4,750 users) ← 5% drop

Step 3: onboarding_completed
  85% (4,250 users) ← 10% drop (large!)

Step 4: first_puzzle_started
  80% (4,000 users) ← 5% drop

Step 5: first_puzzle_completed
  70% (3,500 users) ← 10% drop (large!)

Step 6: aha_moment_reached (Affection Lv1)
  60% (3,000 users) ← 10% drop (target: ≥60% so OK)

→ 大きな drop は Step 3 (onboarding 完了後) と Step 5 (初パズル完成後)
```

**Funnel 改善施策**

```
Drop-off at Onboarding (10%)
  仮説: チュートリアルが長い/退屈
  施策: チュートリアル短縮 (5 min → 3 min)
  測定: A/B test で Step 3 進捗率 改善確認

Drop-off at First Puzzle Completion (10%)
  仮説: 初パズルが難しい / 完成感がない
  施策: 初パズル難度低下 + 完成演出追加
  測定: A/B test で Step 5 進捗率 改善確認

目標: Aha Moment 到達率 60% → 75% (15% 改善)
```

### Churn Analysis

**定義: Churn**

```
Churn = 何日間もアプリを開かなくなったユーザー

例:
  User A: Sep 1 install → Sep 5 last open → Churned (4 days)
  User B: Sep 1 install → Sep 30 open → Retained (still active)
```

**Churn 因子を特定**

```sql
-- BigQuery: Time to Churn

WITH user_activity AS (
  SELECT
    userId,
    DATE(TIMESTAMP(timestamp)) as activity_date,
    eventType,
    eventData.affectionLevel as affection_level,
  FROM `nuripazu.user_events_raw`
  WHERE eventType IN ('app_launched', 'animal_interacted', 'puzzle_completed')
)

SELECT
  userId,
  MIN(activity_date) as first_open,
  MAX(activity_date) as last_open,
  DATE_DIFF(MAX(activity_date), MIN(activity_date), DAY) as days_active,
  
  -- Churn signal: 3+ days no activity
  CASE 
    WHEN DATE_DIFF(CURRENT_DATE(), MAX(activity_date), DAY) >= 3 
    THEN TRUE 
    ELSE FALSE 
  END as is_churned,
  
  -- Affection decay signal
  (SELECT MAX(affection_level) FROM user_activity ua2 
   WHERE ua2.userId = ua.userId) as max_affection_reached,
  
FROM user_activity ua
GROUP BY userId
HAVING DATE_DIFF(CURRENT_DATE(), MAX(activity_date), DAY) >= 1
ORDER BY last_open DESC;
```

**Churn Segment**

```
Segment 1: Early Churners (Day 1-3)
  Count: 500 users (10% of installs)
  Last Affection: None (never reached Aha)
  → Solution: Improve Onboarding (Funnel analysis より)

Segment 2: Mid Churners (Day 4-14)
  Count: 1,000 users (20% of installs)
  Last Affection: Lv 1-2
  → Solution: Add engagement loop (notification, limited event)

Segment 3: Late Churners (Day 15+)
  Count: 1,500 users (30% of installs)
  Last Affection: Lv 3-4
  → Solution: Retention push (new animals, rewards)
  → Hypothesis: Affection decay (3日 no touch → Lv down)
     Fix: Reduce decay to 2 days, Add push notifications

→ 合計 3,000 users (60%) がチャーン状態
   → Reactivation campaign で 20% recover = +600 MAU
```

---

## Step 3: A/B Testing & Optimization (Month 4-6)

### A/B Test Framework

**Test 1: Onboarding Duration**

```
Hypothesis: チュートリアルを短縮すると Step 3 (onboarding 完了) の進捗↑

Control (Current): 5 min tutorial with 7 steps
Variant A: 3 min tutorial with 4 steps
Variant B: 2 min tutorial with 2 steps

Metrics:
  Primary: onboarding_completion rate (Target: 85% → 90%+)
  Secondary: aha_moment_reached rate
  Guardrail: crash_rate (must not increase)

Sample Size: 2,000 users per variant
Duration: 7 days
```

**実装: Firebase Remote Config**

```json
{
  "tutorial_variant": {
    "control": {
      "num_steps": 7,
      "duration_minutes": 5,
      "variant_name": "current"
    },
    "variant_a": {
      "num_steps": 4,
      "duration_minutes": 3,
      "variant_name": "short"
    },
    "variant_b": {
      "num_steps": 2,
      "duration_minutes": 2,
      "variant_name": "minimal"
    }
  },
  "tutorial_variant_assignment": {
    "control_traffic": 33,
    "variant_a_traffic": 33,
    "variant_b_traffic": 34
  }
}
```

**Dart コード**

```dart
// lib/services/onboarding_service.dart

class OnboardingService {
  final remoteConfig = FirebaseRemoteConfig.instance;
  
  Future<List<TutorialStep>> getTutorialSteps() async {
    final variant = remoteConfig.getString('tutorial_variant');
    final variantData = jsonDecode(variant);
    
    // User を A/B group に assign
    String assignedVariant = _assignUserToVariant();
    
    final config = variantData[assignedVariant];
    
    // ステップ数に基づいて tutorial steps を生成
    return _generateTutorialSteps(config['num_steps']);
  }
  
  String _assignUserToVariant() {
    // User ID の hash を使って deterministic に分割
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final hash = uid.hashCode.abs();
    final pct = hash % 100;
    
    if (pct < 33) return 'control';
    if (pct < 66) return 'variant_a';
    return 'variant_b';
  }
}
```

**分析結果 (Day 7)**

```
Control:   85.2% (onboarding_completion)
Variant A: 89.5% (↑ 4.3 pp) ✅ Winner
Variant B: 87.1% (↑ 1.9 pp)

→ Variant A を winner として全ユーザーに roll out
   予想効果: installs 10K の場合、month after は 10K * 4.3% = 430 more users in funnel
```

**Test 2-5: その他の A/B Test**

```
Test 2: First Puzzle Difficulty
  Control: Normal
  Variant: Easy
  → Completion rate, Aha moment rate improve?
  
Test 3: Affection Decay Rate
  Control: 3 days no touch
  Variant A: 2 days no touch
  Variant B: 4 days no touch
  → D7/D30 retention に効果?
  
Test 4: Push Notifications
  Control: No notifications
  Variant A: Day 3 reminder
  Variant B: Day 5 reminder
  → Reactivation rate, notification fatigue?
  
Test 5: Aha Moment Trigger
  Control: Current (Affection Lv 1)
  Variant: Herd Bonus unlock (3 animals)
  → More motivating aha moment?
```

---

## Step 4: Scaling & Growth (Month 6-9)

### User Acquisition Optimization

**Organic Growth Sources**

```
Source 1: App Store Search
  Keywords: puzzle, animal, relaxing, casual game
  Target: Top 10 in "Games > Casual" for each region
  Action: ASO (App Store Optimization)
    • Screenshot optimization (A/B test)
    • Description update with keyword
    • Review rating increase

Source 2: App Store Feature
  Target: "Games We Love" section
  Action: Reach out to App Store editorial
    • Press kit with preview
    • Marketing timeline alignment
    • Month 3-4 に feature 獲得予想

Source 3: Press & Media
  Target: Tech media (AppBank, Engadget, 4Gamer)
  Action: Press release + review copies
    • Launch announcement
    • Monthly milestone celebrations
    • Feature story pitches (ユーザー stories)

Source 4: Social Media & Creator
  Target: YouTube, Twitch, Twitter communities
  Action: Creator program
    • Early access
    • Referral codes
    • Revenue share (views × rate)
```

**Paid Acquisition (Optional, Month 6+)**

```
Channel: iOS App Install Campaigns
  Budget: ¥100K/month
  Target CPI: ¥50-100
  Expected Installs: 1,000-2,000/month
  
  Campaign 1: Broad targeting (all interests)
  Campaign 2: Lookalike (existing users)
  Campaign 3: Competitor targeting (puzzle, casual games)
  
Measurement:
  KPI: CPI vs LTV (ユーザーの lifetime value)
  Payback Period: 30 days (target)
  ROAS: 3:1 (target: 1 install cost の 3倍 revenue in 90 days)
```

### Viral Coefficient Optimization

**定義: Viral Coefficient (k)**

```
k = (Organic New Users from Existing) / (Total Installs)

例:
  Total Installs Month 1: 10,000
  Organic from shares/referral: 3,500
  k = 3,500 / 10,000 = 0.35
  
k > 1 = exponential growth
k = 0.5 = sustainable growth (initial acquire の 50% 自動増殖)
```

**Share Conversion Optimization**

```
Current Flow:
  User A (at Herd Bonus unlock)
    → "Share" button tap
    → Generate shareable image
    → Twitter / LINE / Instagram
    → User B clicks link
    → App Store install
    → App opens to Herd Bonus scene
    
Conversion Rates:
  % who tap Share: 5%
  % Share → Install: 10%
  % Install → active: 80% (D1 retention)
  
Overall: 5% × 10% × 80% = 0.4% viral conversion
Target: 0.7% (75% improvement)

Optimization:
  1. Share button prominence ↑ (bigger, better placed)
  2. Share incentive (bonus affection for sharer)
  3. Deep link personalization (show Herd Bonus preview)
  4. Share UI/UX test (multiple share designs)
```

---

## Step 5: Long-term Strategy (Month 9-12)

### Feature Expansion

**Feature 1: Social / Guilds (Month 8-10)**

```
Concept: ユーザー同士が "Guild" を作って
  • Guild-specific animals (rare, powerful)
  • Guild quests (collaborative puzzle)
  • Guild leaderboards (top 10 displays)
  • Guild chat (asynchronous)

Expected Impact:
  • DAU +15% (social engagement loop)
  • Session duration +20% (social interaction)
  • Revenue +10% (guild-exclusive cosmetics)
  • Viral coefficient +0.1 (friend invite)
```

**Feature 2: Seasonal Battle Pass (Month 10-11)**

```
Concept: Monthly season with progression rewards
  • Free track: 50 levels, cosmetics & affection points
  • Premium track: ¥500/month, exclusive animals & cosmetics
  
Expected Impact:
  • Revenue +30% (premium tier conversion)
  • Engagement +10% (season progression motivation)
  • Churn -5% (season extension retention)
```

**Feature 3: Limited-time Events (Month 12+)**

```
Calendar:
  Week 1-4: Halloween (3 limited animals)
  Week 5-8: Thanksgiving (2 limited animals)
  Week 9-12: Christmas (4 limited animals)
  
Expected Impact:
  • Organic installs +20% per event (trending)
  • DAU spike +50% during event
  • Revenue spike +100% during event
  • Viral coefficient +0.05 per event (FOMO share)
```

### International Expansion

**Phase 1: English localization (Month 8-9)**

```
• All text translations (UI, dialogs, descriptions)
• Right-to-left support (future: Arabic, Hebrew)
• Localized animal names & trivia

Target: USA, UK, Canada, Australia
Expected Install Growth: +25% from English regions
```

**Phase 2: Japan Regional Tweaks (Month 10)**

```
• Hiragana/Kanji balance in descriptions
• Japanese seasonal events (New Year, Tanabata)
• Japanese celebrity partnerships

Target: +10% in Japan from localization
```

---

## 📊 KPI Dashboard Template

### Real-time Dashboard (Updated Daily)

```yaml
Acquisition:
  Yesterday Installs: 500 (target: 300+)
  Last 7d Installs: 3,500
  Install Source: 70% Organic, 20% Paid, 10% Direct

Engagement:
  DAU: 5,500 (↑ 500 from yesterday)
  MAU: 12,000
  DAU/MAU: 46%
  Avg Session: 12 min
  
Retention:
  D1: 65% ✅
  D7: 18% ✅
  D30: 8% ✅
  Churn Rate: 35% D1, 50% D7, 60% D30 (inverse of retention)

Monetization:
  Revenue: ¥15,000 yesterday
  Paying Users: 75 (0.5% of DAU)
  ARPU: ¥15 (Yesterday avg)
  ARPPU: ¥200 (Paying user avg)

Quality:
  Crash-Free: 99.8% ✅
  ANR: 0.1%
  Slowness: 0.3%
  
Content:
  Aha Moment Rate: 62% ✅
  Herd Bonus Rate: 35%
  Share Rate: 5%
```

### Monthly Cohort Report

```markdown
## Monthly Cohort Report - September 2026

### Installs & Retention by Week

| Cohort | Installs | D1 | D7 | D30 | Status |
|--------|----------|----|----|-----|--------|
| Sep 1-7 | 5,000 | 65% | 18% | 8% | Baseline |
| Sep 8-14 | 5,500 | 66% | 19% | 9% | ↑ 1pp |
| Sep 15-21 | 6,000 | 67% | 20% | 10% | ↑ 2pp |
| Sep 22-28 | 6,500 | 68% | 21% | 11% | ↑ 3pp |

→ 新動物・最適化の効果で retention trending up
```

---

## ✅ Phase 10 完了チェックリスト

### Month 1: Foundation

```
□ GA4 ダッシュボード構築完了
□ Firebase BigQuery 統合完了
□ Dart Analytics SDK 実装
□ User Events ログ記録開始
□ Daily KPI レポート自動生成
```

### Month 2-3: Analysis

```
□ Cohort Analysis 実行
□ Funnel Analysis で drop-off 特定
□ Churn Segmentation 完了
□ Churn 因子 Top 3 特定
□ Reactivation campaign 設計
```

### Month 4-6: A/B Testing

```
□ 5+ A/B Tests 実施
□ Test 1: Onboarding → 30%+ improvement
□ Test 2: Difficulty → D1 retention ↑
□ Test 3: Decay Rate → D7 retention ↑
□ Test 4: Notifications → Reactivation ↑
□ Winning variants を production に roll out
```

### Month 6-9: Growth

```
□ Viral Coefficient 0.35 → 0.5+ achieve
□ ASO optimization started
□ Press coverage 3+ articles
□ Creator partnerships 5+
□ Paid acquisition test (optional) starting
```

### Month 9-12: Long-term

```
□ Feature 1: Guild system (or alternative)
□ Feature 2: Season/Pass system (or alternative)
□ International expansion (English)
□ Year 1 milestone: 100K+ MAU achieve
```

---

## 📞 Key Tools & Resources

```
Analytics:
  • Firebase Console: https://console.firebase.google.com/
  • Google Analytics 4: https://analytics.google.com/
  • Google BigQuery: https://cloud.google.com/bigquery
  
Tools:
  • Google Data Studio (visualization)
  • Mixpanel (optional alternative to Firebase)
  • Amplitude (optional, cohort analysis focus)
  
Documentation:
  • GA4 Setup Guide: https://support.google.com/analytics/
  • Firebase Analytics: https://firebase.google.com/docs/analytics
  • BigQuery for Games: https://cloud.google.com/solutions/gaming-analytics
```

---

**Version**: 1.0  
**Phase**: 10 Post-Launch Analytics & Optimization  
**Duration**: 6-12 months (継続的)
