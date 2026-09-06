# Phase 9E: Google Play Submission - Quick Reference

**用途**: Google Play Store 審査申請の最速チェックリスト  
**対象**: Product マネージャー  
**実装時間**: 5-7 営業日

---

## 🎯 5 分でわかる Phase 9E

```
Phase 9D: App Store 承認済み ✅
  ↓ (並行実行)
Step 1: Android ビルド準備 (1-2時間)
  ├─ flutter build appbundle --release
  └─ AAB ファイル生成
  ↓
Step 2: Google Play Console 入力 (2-3時間)
  ├─ アプリ名・説明・キーワード
  ├─ スクリーンショット 4-8枚
  ├─ コンテンツレーティング・プライバシー
  └─ Data Safety 設定
  ↓
Step 3: 審査申請 (1時間)
  └─ AAB アップロード → 「本番環境への提出」
  ↓
Step 4: 審査監視 (2-5日)
  └─ Daily 確認 → In Review → Approved
  ↓
Step 5: プリレジスター + 公開 (1日)
  └─ 「プリレジスター」有効化 → 公開
```

---

## ⚡ Step-by-Step Checklist

### Step 1: Android ビルド準備 (1-2時間)

```bash
# Release ビルド生成
flutter build appbundle --release
# 出力: build/app/outputs/bundle/release/app-release.aab

# ビルドサイズ確認
ls -lh build/app/outputs/bundle/release/app-release.aab
# 150MB 以下が推奨

# バージョン確認
grep "^version:" pubspec.yaml
# 出力: version: 1.0.0+1

# 署名キーストア確認
keytool -list -v -keystore ~/.android/release-keystore.jks
# Alias: release
# Valid for: 25+ years
```

### Step 2: Google Play Console 入力 (2-3時間)

**2.1 基本情報**

```
Google Play Console
  → ぬりパズ動物園 を選択
  → ストアの掲載情報 タブ

App Name:              ぬりパズ動物園 (50文字以内)
Short Description:    宝石パズル × 動物育成 (80文字以内)
Full Description:     (以下テンプレート参照)
Promotional Text:     毎日触れて、動物とのきずなを育成 (80文字以内)
```

**推奨 Full Description (コピペ用)**

```
宝石パズルを完成させると、そこに動物が現れる。
完成は終わりじゃなく、新しい始まり。

毎日触れると、動物があなたに心を寄せてくる。
3日間会わないと、ちょっと寂しそうになる。

同じ色の動物を3体揃えると、
生息地でミニシーンが繰り広げられる。

育成ゲームの奥深さと、
パズルの爽快感が一つになった新感覚。

シンプルだけど、やめられない。
そんなぬりパズ動物園へようこそ。

【ぬりパズ動物園の特徴】
• 簡単だけど奥深い宝石パズル
• 100種類以上の動物が登場
• 動物ごとの個性的なリアクション
• 毎日交流して、なつき度を育成
• 3体の群れボーナスで新しい演出
• 癒し系の柔らかいビジュアル
```

**2.2 カテゴリ・レーティング**

```
Game Type: Casual Games
Category: Puzzle

Content Rating (IARC):
  暴力:             なし ✅
  セクシャル:       なし ✅
  有害コンテンツ:   なし ✅
  アルコール・タバコ: なし ✅
```

**2.3 スクリーンショット**

| # | デバイス | 解像度 | 形式 |
|---|---------|--------|------|
| 1 | Phone | 1080×1920 | PNG |
| 2 | Phone | 1080×1920 | PNG |
| 3 | Phone | 1080×1920 | PNG |
| 4 | Phone | 1080×1920 | PNG |
| 5-8 | Phone | 1080×1920 | PNG (オプション) |

**2.4 プライバシー・Data Safety**

```
Privacy Policy URL:    https://yourwish.dev/privacy/ja

Data Collected:
  ☑️ User IDs (Firebase)
  ☑️ Game progress (Firestore)
  ☑️ Analytics (Firebase Analytics)
  ☑️ Payment info (RevenueCat)
  ☑️ Advertising ID (Google AdMob)

Data Purpose:
  ☑️ App functionality
  ☑️ Analytics
  ☑️ Advertising
  ☑️ Security

Data Sharing:
  ☑️ Google (Firebase)
  ☑️ RevenueCat
  ☑️ Google AdMob
```

**2.5 価格・配布**

```
Price:                Free (with IAP)
  ☑️ 広告: はい
  ☑️ In-App Purchases: はい
  
Distribution:
  ☑️ Japan (必須)
  ☑️ United States (推奨)
```

### Step 3: 審査申請 (1時間)

**最終チェック**

```
□ アプリ名・説明: 完成 ✅
□ スクリーンショット: 4-8枚 ✅
□ カテゴリ・レーティング ✅
□ プライバシー: URL有効 ✅
□ Data Safety: 完成 ✅
□ AAB ファイル: 準備 ✅
```

**AAB アップロード**

```
Google Play Console
  → リリース
  → テスト版 → 本番
  → 「新しいリリースを作成」
  → AAB ファイルを選択
    build/app/outputs/bundle/release/app-release.aab
```

**リリース詳細を入力**

```
Version: 1.0.0
Build: 1
Release Notes: 初リリース: パズル × 動物育成ゲーム
```

**申請実行**

```
Google Play Console
  → 「本番環境への提出」
  → ポリシー同意
  → 「提出」
```

**結果**

```
✅ 申請成功
   状態: In Review (審査中)
```

### Step 4: 審査監視 (2-5日)

**毎日確認**

```
Google Play Console
  → ぬりパズ動物園
  → リリース
  → 本番
  → 画面上部の「状態」欄
```

**状態遷移**

```
1. In Review (12-48時間)
   → Google チーム審査中

2. Approved (承認!) ✅
   → プリレジスター 自動表示

2. Rejected (稀)
   → 理由確認 → 修正 → 再提出
```

**Rejected 時の対応**

| リジェクト理由 | 対応 |
|-------------|------|
| Policy Violation (広告) | AdMob 設定確認 → 修正 → 再提出 |
| Policy Violation (課金) | RevenueCat 確認 → 修正 → 再提出 |
| Compatibility Issues | Android テスト確認 → 修正 → 再提出 |
| Privacy Policy 不備 | URL 更新 → 再提出 |
| ビルド情報不完全 | 全項目再確認 → 再提出 |

### Step 5: プリレジスター + 公開 (1日)

**Approved 状態で自動実行**

```
Google Play Console
  → リリース
  → 本番
  → リリース設定
  → 段階的ロールアウト: 100%
```

**プリレジスター バナー確認**

```
Google Play Store (ユーザー視点)
  → ぬりパズ動物園 を検索
  → プリレジスター バナー表示
  → ボタンクリックで事前登録可能

確認項目:
  ✅ タイトル表示
  ✅ スクリーンショット表示
  ✅ プリレジスター ボタン表示
```

**公開実行**

```
100% ロールアウト設定の場合:
  → Approved 後、自動で公開 (通常 1-2時間)

段階的ロールアウト設定の場合:
  → 10% → 50% → 100% と段階展開
```

---

## 📝 Key Values チートシート

```yaml
App Info:
  App Name: ぬりパズ動物園
  Short Desc: 宝石パズル × 動物育成
  Package: com.yourwish.nuripazu
  Version: 1.0.0
  Build: 1
  Min SDK: API 21+ (Android 5.0)
  Target SDK: API 34+

App Store:
  Category: Puzzle
  Game Type: Casual Games
  Rating: Everyone

Support:
  Email: support@yourwish.dev
  Privacy: https://yourwish.dev/privacy/ja

Screenshots:
  Format: 1080×1920 PNG
  Count: 4-8 枚
  Devices: Phone (5.1")

Features:
  IAP: はい (コスメ課金)
  Ads: はい (AdMob)
  Internet: はい (一部機能)
```

---

## ⚠️ よくあるミス

| ミス | 対策 |
|------|------|
| AAB ファイルを .apk として提出 | AppBundle (.aab) を使用 |
| バージョン番号が iOS と異なる | 1.0.0+1 に統一 |
| プライバシーポリシー URL が切れている | HTTPS://yourwish.dev/privacy/ja を確認 |
| 説明文が 4000 文字超過 | 短縮する |
| In-App Purchase を設定し忘れ | 「はい」をチェック |
| 広告チェックボックスをチェック忘れ | 「はい」をチェック |
| スクリーンショット が古い | 最新ビルドで新規キャプチャ |
| Data Safety が未設定 | Firebase / RevenueCat / AdMob 明記 |

---

## 🚨 審査リジェクト時の対応フロー

```
Rejected 通知
  ↓
理由を読む (e.g., "Policy Violation")
  ↓
対応策を特定
  ├─ 広告 → AdMob 設定修正
  ├─ 課金 → RevenueCat 確認
  ├─ 互換性 → Android テスト
  ├─ プライバシー → URL 更新
  └─ その他 → Play ポリシー再読
  ↓
修正実装
  ↓
Android ビルド再生成
  ↓
新 AAB をアップロード
  ↓
Google Play Console で「本番環境への提出」
  ↓
In Review へ (最初から)
```

---

## ✅ Phase 9E 完了チェック

### ビルド準備

```
□ Android ビルド生成完了
□ AAB < 150MB
□ Version 1.0.0+1 確認
□ 署名キーストア有効
```

### Google Play Console

```
□ アプリ名・説明・キーワード
□ スクリーンショット 4-8枚
□ カテゴリ・レーティング
□ プライバシー URL有効
□ In-App Purchases: はい
□ 広告: はい
□ Data Safety 完成
```

### 申請・審査

```
□ 審査申請完了
□ 毎日状況確認
□ Approved 取得
```

### リリース準備

```
□ プリレジスター バナー確認
□ マーケティング素材準備
□ サポート体制準備
□ 公開完了
```

---

## 📞 Support

- **Google Play Console**: https://play.google.com/console/
- **Google Play Policies**: https://play.google.com/about/gpp/
- **Email**: support@yourwish.dev

---

**Version**: 1.0  
**Phase**: 9E Google Play Store Submission  
**Timeline**: 5-7 business days
