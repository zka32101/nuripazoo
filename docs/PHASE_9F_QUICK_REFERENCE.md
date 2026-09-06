# Phase 9F: Live Operations - Quick Reference

**用途**: 公開後のコンテンツ運営・KPI監視の最速ガイド  
**対象**: Product マネージャー・Operations チーム  
**実装時間**: 継続的 (毎月 5-7営業日 + 日次監視)

---

## 🎯 5 分でわかる Phase 9F

```
公開リリース (Friday 18:00 JST)
  ↓
Month 1-2: Acquisition & Engagement
  • DAU 5K+, D1 Retention 65%+
  • マーケティング・PR活動
  ↓
毎月: コンテンツ更新 (新動物 2-3種)
  • スプレッドシート管理
  • petit_ai 絵柄生成
  • データ検証 → Firestore 投入
  • TestFlight → App Store/Play 配信
  ↓
毎月: シーズナルイベント (限定動物)
  • Halloween/Christmas/Valentine
  • Remote Config で期間制御
  ↓
継続: KPI 監視 & 改善
  • 毎日: DAU/MAU, Crash-Free, Revenue
  • 毎週: Retention, ARPU, Viral coefficient
  • 毎月: 戦略会議 & 目標調整
```

---

## ⚡ Quick Checklists

### リリース前 (Final 7 Days)

```bash
# 7日前: リリース準備会議
□ App Store / Google Play 承認状態確認
□ Firebase 本番環境最終テスト
□ RevenueCat 本番課金テスト
□ AdMob 広告表示確認
□ ユーザーサポートスタッフ配置確認
□ マーケティング素材 最終確認
□ プレスリリース スケジュール確認

# 3日前: リリース予行演習
□ App Store: Manual Release シミュレート
□ Google Play: 100% Rollout シミュレート
□ Slack 通知テスト
□ PagerDuty インシデント対応テスト
□ ユーザーサポート チームへ事前通知

# 1日前: 最終チェック
□ ビルド 1 が両ストアで Approved 状態
□ KPI ダッシュボード準備完了
□ 監視チーム スタンバイ確認
□ Twitter/Discord コミュニティ マネージャー待機

# リリース当日 (Friday 18:00 JST)
□ App Store Manual Release 実行
□ Google Play 100% Rollout 実行
□ Slack #release-notifications に投稿
□ Twitter に公開投稿
□ Discord コミュニティに告知
□ リアルタイム監視開始 (最低 2時間)
```

### 月次コンテンツ更新サイクル

**Week 1 (企画・準備)**

```bash
# Monday 09:00: 企画会議
□ 新動物 2-3種の案出し
□ シーズナルテーマ確認 (Q4 なら Halloween)
□ イラストレーター指示準備
□ petit_ai プロンプト作成

# Wednesday: データ入力開始
□ Google Sheet に 新動物情報を入力
  ├─ 動物名 (日本/英)
  ├─ タイプ・個性タグ
  ├─ なつき度リアクション説明
  ├─ 群れボーナス パターン
  └─ イラスト指示
□ petit_ai に投入
  └─ 5-10 パターン 自動生成
□ Product チームで投票
  └─ Top 2-3 を選出

# Friday: 最終確認
□ イラスト完成確認
□ SE/BGM リファレンス指示
□ JSON データ構造 確認
```

**Week 2 (検証・TestFlight)**

```bash
# Monday: Firestore 投入
□ CSV → JSON 変換実行
node scripts/import_animals.js --file animals.csv --validate-only

□ 検証スクリプト実行
  ├─ 重複チェック ✅
  ├─ NGワード確認 ✅
  ├─ タグ妥当性 ✅
  └─ リアクション完成度 ✅

□ Firestore 本投入実行
node scripts/import_animals.js --file animals.csv --apply

# Tuesday: TestFlight ビルド
□ flutter build ios --release --build-number 2
□ App Store Connect にアップロード
□ 内部テスター (5-10人) に配信
□ テスト案内を Slack で配信

# Wednesday-Thursday: 内部テスト
□ 新動物が表示される ✅
□ なつき度が育成できる ✅
□ 群れボーナスが出現する ✅
□ クラッシュなし ✅
□ テスター から フィードバック回収

# Friday: 問題なければ App Store 審査へ
□ Build 2 を本番環境へ昇格
□ App Store Connect で審査申請
□ Google Play への新 AAB アップロード
```

**Week 3-4 (審査・配信)**

```bash
# Day 1-2: App Store 審査
□ 毎日 App Store Connect で状態確認
□ → In Review 中

# Day 2-3: Google Play 審査
□ 毎日 Google Play Console で状態確認
□ → In Review 中

# Day 4-5: 承認完了
□ App Store: Approved ✅
□ Google Play: Approved ✅
□ 自動リリース設定: 有効 ✅

# Day 5: ユーザーに配信
□ App Store: 自動配信開始
□ Google Play: 自動配信開始
□ Slack #release-notifications に投稿
□ Twitter に告知
□ Discord コミュニティで紹介
□ リアルタイム監視 (Crash-Free 確認)
```

### 毎日 KPI 監視 (06:00 JST)

```bash
# Daily Report Script
node scripts/daily_kpi_report.js

📊 Metrics to Check:
  □ DAU: ___ (前日比: ___)
  □ MAU: ___ (週比: ___)
  □ Crash-Free Rate: ___% (target: ≥99.5%)
  □ Session Duration: ___ min
  □ aha_moment_reached: ___% (target: ≥60%)
  □ Revenue: ¥___ (前日比: ___)

🚨 Alerts to Watch:
  □ Crash-Free < 99.5% → P1 インシデント
  □ DAU ↓ 30%+ → 問題調査
  □ Revenue ↓ 50%+ → 課金流路確認
  □ Crash spikes: Crashlytics で原因特定

✅ Green Indicators:
  □ Crash-Free ≥99.5% ✅
  □ DAU trending up ✅
  □ Revenue stable ✅
```

### 毎週 レビュー (Monday 08:00)

```bash
# Weekly Summary
# Excel / Google Sheet に以下を記入:

Week of: 2026-09-01

📈 Retention (Target: D1 65%, D7 18%, D30 8%)
  D1: 65% ✅
  D7: 18% ✅
  D30: 8% ✅
  
💰 Monetization
  Revenue: ¥50,000
  Paying Users: 150
  ARPU: ¥333
  
👥 Growth
  DAU: 5,000 (↑ 500)
  Weekly Installs: 2,000
  Viral Coefficient: 0.35
  
⚠️ Issues
  □ Issue 1: Android crash (50 users)
    → Fix ETA: EOW
  □ Issue 2: Payment flow slow
    → Investigation ongoing
  
✅ Actions for Next Week
  □ Deploy Android hotfix
  □ A/B test: difficulty tuning
  □ Monitor aha_moment_reached
```

### 毎月 戦略会議 (1st of Month, 09:00)

```markdown
# Monthly Strategy - September 2026

## KPI Status vs Target

| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| DAU | 5K+ | 5.2K | ✅ |
| D30 Retention | 8% | 8.1% | ✅ |
| Viral Coeff | 0.3+ | 0.35 | ✅ |
| Revenue | ¥150K | ¥165K | ✅ |
| Crash-Free | 99.5%+ | 99.8% | ✅ |

## Problem Areas

1. **Share-to-Install Low (15% vs 20%)**
   - Solution: A/B test share screen UX
   - Assigned to: [Name]
   - Timeline: Week 2
   
2. **Affection Lv4 Reach Low (5% vs 10%)**
   - Solution: Reduce decay 3d→2d
   - Assigned to: [Name]
   - Timeline: October release

## Planned Updates (October)

- New Animals: 2-3 species
- Event: Halloween (3-4 limited)
- Feature: Push notification reminders
- Optimization: Affection decay tuning

## Approval: [PM Signature]
```

---

## 📝 Content Update Template

### Monthly Animal Data

```yaml
# animals_2026_10.csv

Name,EnglishName,Type,Tags,Lv1_Reaction,Lv2_Reaction,Lv3_Reaction,Lv4_Reaction,Herd_Bonus,Artist,BGM_Reference,Release_Date

キンシコウ,Golden Snub-nosed Monkey,Land,"神秘的,優雅",Turns away slightly,Glances back with curiosity,Sits close and watches,Cuddles peacefully,3体で輝く光演出,petit_ai,Ethereal_Bells,2026-10-01

ヒメウズラ,Japanese Quail,Land,"かわいい,小さい",Chirps from distance,Hops closer,Pecks gently,Snuggles in lap,3体で群れ舞う演出,petit_ai,Nature_Chirps,2026-10-15
```

### Remote Config Template (シーズナルイベント)

```json
{
  "limited_animals_halloween_2026": {
    "enabled": true,
    "start_date": "2026-10-01T00:00:00Z",
    "end_date": "2026-10-31T23:59:59Z",
    "animal_ids": ["bat_1", "pumpkin_1", "ghost_1", "black_cat_1"]
  },
  "limited_animals_christmas_2026": {
    "enabled": false,
    "start_date": "2026-12-01T00:00:00Z",
    "end_date": "2026-12-25T23:59:59Z",
    "animal_ids": ["reindeer_1", "snowman_1", "santa_penguin_1"]
  }
}
```

---

## 🚨 Incident Response

### Critical: Crash-Free < 98%

```
ALERT: Crash-Free Rate dropped to 97.2%

Immediate Actions:
  1. Crashlytics で Top Crashes を確認
  2. Stack trace から原因を特定
  3. GitHub issue を開く (P1)
  4. dev-on-call を呼ぶ
  5. Hotfix ブランチを作成
  6. 30分以内に修正試案を出す

Deployment:
  1. Hotfix テスト完了
  2. flutter build appbundle --release --build-number 3
  3. App Store + Google Play にアップロード
  4. 急速審査リクエスト (24時間目安)
  5. 承認後即配信

Monitoring:
  1. Crash-Free がリアルタイム改善するか確認
  2. 24時間 99.5%+ 維持できるまで監視
```

### High: Revenue Drop > 50%

```
ALERT: Daily revenue dropped ¥50K → ¥25K

Investigation:
  1. RevenueCat dashboard で transaction を確認
  2. App Store Connect で receipt validation error を確認
  3. Google Play で payment issues を確認
  4. Firestore で purchase records を確認

Possible Causes:
  ☐ Payment gateway down (RevenueCat/Apple/Google)
  ☐ Code issue (receipt validation logic)
  ☐ Configuration issue (API keys invalid)
  ☐ User behavior change (sudden churn)

Response:
  1. Status page (status.yourwish.dev) で users に通知
  2. [On-call Dev] に escalate
  3. Rollback if code was recently deployed
  4. Root cause analysis report 作成
```

---

## 📊 Success Timeline & Targets

```
Month 1:
  □ DAU: 5,000+
  □ D1 Retention: ≥65%
  □ Crash-Free: ≥99.5%
  □ Revenue: ¥100K

Month 3:
  □ DAU: 6,000
  □ D7 Retention: ≥18%
  □ D30 Retention: ≥8%
  □ Revenue: ¥300K

Month 6:
  □ DAU: 8,000
  □ Viral Coefficient: ≥0.4
  □ Revenue: ¥500K
  □ Animals: 75+ species

Month 12:
  □ DAU: 10,000+
  □ Viral Coefficient: ≥0.5
  □ Revenue: ¥1M+
  □ Animals: 150+ species
```

---

## 📞 Key Tools & Links

```
Monitoring:
  • Firebase Console: https://console.firebase.google.com/
  • Google Analytics 4: https://analytics.google.com/
  • Slack: #release-notifications, #incidents
  
Distribution:
  • App Store Connect: https://appstoreconnect.apple.com/
  • Google Play Console: https://play.google.com/console/
  
Revenue:
  • RevenueCat: https://app.revenuecat.com/
  • App Store Connect (Financial Reports)
  
Community:
  • Discord: (Community link)
  • Twitter: @nuripazu
  • Support: support@yourwish.dev
```

---

**Version**: 1.0  
**Phase**: 9F Live Operations & Content Management  
**Update Frequency**: Daily (monitoring) + Monthly (content updates)
