# Phase 9E: Google Play Store Submission

**用途**: Google Play Store 審査申請から「Coming Soon」段階までの完全ガイド  
**対象**: Product マネージャー・デベロッパー  
**実装時間**: 5-7 営業日

---

## 📋 Phase 9E 概要

Phase 9D (App Store) で承認を取得した後、並行して Google Play Store での審査申請を実行します。

```
Phase 9D: App Store 承認済み (Coming Soon)
    ↓ (並行実行)
Phase 9E: Google Play Store 申請
    ├─ Step 1: Android ビルド準備
    ├─ Step 2: Google Play Console 情報入力
    ├─ Step 3: アプリ審査申請
    ├─ Step 4: 審査状況監視
    └─ Step 5: 承認後の「プリレジスター」設定
    ↓
Google Play Store 承認 → 日本・米国での配信開始
```

---

## 🎯 Phase 9E Success Criteria

✅ **全てのクリティア達成で配信準備完了**

```
□ Google Play Console でビルド承認
□ アプリ審査申請完了
□ Google Play チーム承認済み
□ 「プリレジスター」表示が有効
□ 日本・米国での配信確認
□ ストア掲載情報 (スクショ・説明) 最終確認
```

---

## Step 1: Android ビルド準備 (1-2時間)

### Android ビルドの生成

```bash
# Flutter release ビルド
cd /path/to/nuripazu
flutter build appbundle --release

# 出力: build/app/outputs/bundle/release/app-release.aab
ls -lh build/app/outputs/bundle/release/app-release.aab
```

**ビルド仕様の確認**:

```bash
# pubspec.yaml で version を確認
grep "^version:" pubspec.yaml
# 出力例: version: 1.0.0+1

# android/app/build.gradle で versionCode/versionName を確認
grep -E "versionCode|versionName" android/app/build.gradle
# 出力例:
#   versionCode 1
#   versionName "1.0.0"
```

**推奨バージョン** (iOS と同じ):
- Version Name: `1.0.0`
- Version Code: `1` (初回)
- Minimum SDK: API 21+ (Android 5.0)
- Target SDK: API 34+ (最新)

### 署名キーストアの確認

```bash
# キーストア情報を確認
keytool -list -v -keystore ~/.android/release-keystore.jks
# 入力: キーストア パスワード
```

**確認項目**:
- [ ] Alias: `release` (または設定名)
- [ ] Valid for: 25+ years (有効期限)
- [ ] Signature algorithm: SHA256withRSA

### Firebase App Distribution へのテスト配信 (オプション)

```bash
# Firebase に最終ビルドをテスト配信
# Google Play Console 申請前の最終テスト

firebase apps:list
# 出力: Android アプリ ID を確認

# または App Store Connect と同様に TestFlight 相当で配信
```

---

## Step 2: Google Play Console 情報入力 (2-3時間)

### 2.1 Google Play Console へのアクセス

```
https://play.google.com/console/ 
  → ぬりパズ動物園 を選択
  → ストアの掲載情報 タブ
```

### 2.2 アプリ基本情報

**アプリ名と説明**

| フィールド | 値 | 制限 |
|-----------|-----|------|
| App Name | ぬりパズ動物園 | 50文字以内 |
| Short Description | 宝石パズル × 動物育成 | 80文字以内 |
| Full Description | (以下参照) | 4,000文字以内 |
| Promotional Text | 毎日触れて、動物とのきずなを育成 | 80文字以内 |

**推奨 Full Description** (日本語):

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

【安心な機能設計】
• シンプルで分かりやすい操作
• 無料でご利用可能
• 広告が表示されます
• お好みに応じてコスメ課金も選択可能
```

### 2.3 カテゴリ・コンテンツレーティング

**Content Rating**

```
Game Type: Casual Games
Category: Puzzle

Content Rating (IARC):
  暴力: なし
  セクシャルコンテンツ: なし
  有害コンテンツ: なし
  アルコール・タバコ: なし
```

**Sensitive Permissions** (自動検出):

```
Camera: いいえ
Microphone: いいえ
位置情報: いいえ
個人情報へのアクセス: いいえ
```

### 2.4 スクリーンショット・プレビュー動画

**各デバイスのスクリーンショット (4-8枚推奨)**

| デバイス | 解像度 | 枚数 | 説明 |
|---------|--------|-----|------|
| Phone (5.1") | 1080×1920 | 4-8 | 各画面のキャプチャ |
| 7" Tablet | 1080×1920 | オプション | タブレット対応確認 |

**スクリーンショット内容** (App Store と同じ):
1. パズル画面 - 宝石を消す爽快感
2. 完成演出 - 動物が現れる瞬間
3. 動物詳細 - なつき度を育成
4. 群れボーナス - 3体揃ったミニシーン
5. 図鑑・コレクション - 100種類の動物
6. ホーム画面 - 動物園の全景

**プレビュー動画** (オプション):
- 長さ: 15-30秒
- 解像度: 1080×1920 (縦向き)
- フォーマット: MP4 (H.264)
- BGM・効果音付き推奨

### 2.5 プライバシーとセキュリティ

**Privacy Policy URL**
```
https://yourwish.dev/privacy/ja
```

**Data Safety** (Google Play ポリシー)

```
Data Collected:
  □ Personal info (name, email)
  ☑️ User IDs (Firebase UID)
  ☑️ Game progress (Firestore)
  ☑️ Analytics (Firebase Analytics)
  ☑️ Payment info (RevenueCat)
  ☑️ Advertising ID (Google Mobile Ads)

Data Purpose:
  ☑️ App functionality
  ☑️ Analytics & improvement
  ☑️ Advertising personalization
  ☑️ Security & fraud prevention

Data Sharing:
  ☑️ Google (Firebase)
  ☑️ RevenueCat (payments)
  ☑️ Google AdMob (ads)
  ☐ Other third parties

Data Retention:
  □ Data can be deleted by user
  ☑️ Data auto-deleted after inactivity
  ☑️ Support email for data deletion

Data Security:
  ☑️ Encryption in transit (HTTPS)
  ☑️ Secure authentication
  ☐ No third-party access
```

### 2.6 価格・配布地域

**Pricing**

```
Free (with in-app purchases)
  ☑️ 広告: はい
  ☑️ In-App Purchases: はい (コスメ課金)
  ☑️ Subscriptions: いいえ
```

**Distribution**

```
Available Countries:
  ☑️ Japan (必須)
  ☑️ United States (推奨)
  ☑️ Global (optional - 将来)

Target Audience:
  ☑️ Everyone
  ☑️ Mature audiences: いいえ
```

---

## Step 3: アプリ審査申請 (1時間)

### ビルド (AAB) のアップロード

```
Google Play Console
  → ぬりパズ動物園
  → リリース
  → テスト版 → 本番
  → 「新しいリリースを作成」
```

**アップロード手順**:

```
1. AAB ファイルを選択
   build/app/outputs/bundle/release/app-release.aab

2. リリース版の詳細を入力
   Version: 1.0.0
   Build: 1

3. リリースノートを入力 (日本語)
   例: 初リリース: パズル × 動物育成ゲーム

4. 審査に提出
   「確認」→「本番環境への提出」
```

**確認画面**:

```
ストアの掲載情報: 完成 ✅
  ├─ アプリ名・説明 ✅
  ├─ スクリーンショット ✅
  ├─ プライバシー ✅
  └─ コンテンツレーティング ✅

ビルド: 準備完了 ✅
  ├─ AAB ファイル ✅
  ├─ Version 1.0.0 ✅
  └─ 署名検証済み ✅
```

### 提出実行

```
Google Play Console
  → 本番環境への提出
  → ポリシーへの同意
  → 「提出」
```

**提出完了**

```
✅ 申請成功
   状態: In Review (審査中)
   審査予想時間: 24-48時間 (通常)
```

---

## Step 4: 審査状況監視 (毎日確認)

### Google Play 審査の進み方

```
1. In Review (提出直後)
   └─ Google 審査チームが実装をレビュー (12-48時間)
   └─ チェック項目:
      • ポリシー違反なし
      • クラッシュなし
      • プライバシー適切
      • 広告実装適切
      • 課金実装適切
      • デバイス互換性確認

2. Rejected (稀: 否認)
   └─ 理由が通知される
   └─ 修正 → 再提出

3. Approved (承認!)
   └─ 公開準備完了
   └─ プリレジスター は自動開始
```

### 審査状況の確認方法

```bash
# 毎日確認
# Google Play Console
#   → ぬりパズ動物園
#   → リリース
#   → 本番
#   → 画面上部の「状態」欄
```

**Rejected の場合の対応**

```
例: "Policy Violation - Deceptive Behavior"
    理由: 広告実装が不適切

→ 対応:
  1. Google Play ポリシーを確認
  2. AdMob 実装を修正
  3. Android ビルドを再生成
  4. 新 AAB をアップロード
  5. 再度「本番環境への提出」
```

### 審査期間の活動

**審査中にできること**:

```
✅ できる:
  • プリレジスター ページのカスタマイズ
  • マーケティング資料の編集
  • グローバル展開の準備
  • MediaKit・プレスリリース準備

❌ できない:
  • 審査中のポリシー変更
  • バージョン番号の変更
  • 新しい AAB のアップロード (再提出の場合を除く)
```

---

## Step 5: 「プリレジスター」設定と公開準備 (1日)

### プリレジスター ページの有効化

```
Google Play Console
  → リリース
  → 本番
  → リリース設定
    → 段階的ロールアウト (Gradual Rollout)
```

**公開方法の選択**:

```
☑️ 100% ロールアウト
   → 承認後、即座に 100% 公開
   推奨: このオプション (全ユーザーにすぐ提供)

☐ 段階的ロールアウト
   → 承認後、段階的に展開 (例: 10% → 50% → 100%)
   推奨: 問題検出時の対応時間が必要な場合
```

### プリレジスター バナーの確認

```
Google Play Store (ユーザー視点)
  → ぬりパズ動物園 を検索
  → プリレジスター バナー表示
  → プレビュー動画・説明文表示

確認項目:
  ✅ アイコン表示
  ✅ タイトル表示
  ✅ スクリーンショット表示
  ✅ プリレジスター ボタン表示
```

### マーケティング素材の確認

```
Google Play Store に表示される項目:

✅ アプリアイコン
   └─ 512×512px (自動)

✅ タイトル: ぬりパズ動物園
   └─ 50文字以内

✅ Short Description: 宝石パズル × 動物育成
   └─ 80文字以内

✅ Full Description
   └─ 4,000文字以内

✅ スクリーンショット: 4-8枚
   └─ 1080×1920px

✅ プレビュー動画 (オプション)
   └─ 15-30秒 MP4

✅ Featured Image (バナー)
   └─ 1024×500px (推奨)
```

### 配信地域の確認

```
Pricing and Distribution
  → Available Countries
    ├─ Japan: ✅ (必須)
    ├─ United States: ✅ (推奨)
    ├─ その他グローバル: ✅ (将来的に)
```

---

## 🚨 よくあるリジェクト理由と対応

### リジェクト 1: Policy Violation - Deceptive Behavior (広告)

```
理由: Ads are too prominent or misleading

対応:
  1. Google Play ポリシーを確認:
     https://play.google.com/about/gpp/
  
  2. AdMob 設定を確認:
     - バナー広告は画面下部のみ
     - リワード広告は ユーザーの明示的操作後
     - インタースティシャルは 画面遷移時のみ
  
  3. 広告とコンテンツの混在を解消
  
  4. Android ビルド再生成 → 新 AAB アップロード
  
  5. 再度提出
```

### リジェクト 2: Policy Violation - Payments

```
理由: In-app purchase does not follow guidelines

対応:
  1. RevenueCat 実装を確認:
     - 無料体験は明記されているか
     - キャンセル方法が簡単か
     - 購入確認が明示的か
  
  2. Google Play Billing Library を確認:
     - 最新版を使用しているか
     - 支払い検証が実装されているか
  
  3. ビルド修正 → 再度提出
```

### リジェクト 3: Compatibility Issues

```
理由: App crashes on devices running Android 11+

対応:
  1. Android 11+ デバイスでテスト
     (エミュレータ: API 30+)
  
  2. Crashlytics でクラッシュ原因を確認
  
  3. Android 版固有のバグを修正
  
  4. Flutter: flutter clean → flutter build appbundle
  
  5. 新 AAB アップロード → 再度提出
```

### リジェクト 4: Privacy Policy Issues

```
理由: Privacy policy does not explain data collection

対応:
  1. https://yourwish.dev/privacy/ja を更新
  
  2. Google Play での収集データ明記:
     - Firebase ユーザーID
     - ゲーム進捗
     - Analytics イベント
     - 広告ID
  
  3. 使用目的・第三者共有を明記
  
  4. ユーザーが削除リクエストできる方法を記載
  
  5. 再度提出
```

---

## ✅ Phase 9E 完了チェックリスト

### ビルド準備

```
□ Android ビルド生成完了
□ AAB ファイルサイズ確認 (< 150MB 推奨)
□ 署名キーストア有効
□ firebase-play-services 統合
```

### Google Play Console 入力

```
□ アプリ名・説明・キーワード
□ スクリーンショット 4-8枚
□ カテゴリ・コンテンツレーティング
□ プライバシー URL有効
□ In-App Purchases: はい
□ 広告: はい
□ Data Safety: 完成
```

### 申請・監視

```
□ 審査申請完了 (In Review)
□ 毎日審査状況を確認
□ リジェクトの場合は対応
□ Approved 状態を確認
```

### リリース準備

```
□ プリレジスター ページが表示されている
□ スクリーンショット・説明が正しい
□ マーケティング素材準備完了
□ ユーザーサポート体制準備
```

---

## 📊 Phase 9E タイムライン

```
Day 1 (2-3時間)
  → Android ビルド生成
  → Google Play Console 情報入力
  → 審査申請

Day 1-2
  → 「In Review」状態確認

Day 2-3
  → Google による審査実施
  → 審査状況を監視

Day 3-5
  → 承認 (「Approved」) 待機

Day 5
  → プリレジスター バナーが Google Play Store に表示
  → 公開 (100% ロールアウト)

Day 6+
  → アプリ公開 🎉
  → ユーザーダウンロード開始 (日本・米国)
```

---

## 📞 Key Links

- **Google Play Console**: https://play.google.com/console/
- **Google Play Policies**: https://play.google.com/about/gpp/
- **Privacy Policy**: https://yourwish.dev/privacy/ja
- **Support**: support@yourwish.dev

---

## 🚀 Phase 9E 完了時の状態

```
✅ Google Play Store で「プリレジスター」表示
✅ Google 審査承認済み
✅ 日本・米国での配信確認
✅ マーケティング素材確認完了
✅ ユーザーサポート体制準備完了

→ 次フェーズ (Phase 9F ライブオペレーション) へ
→ または全体公開 (iOS + Android)
```

---

**Version**: 1.0  
**Phase**: 9E Google Play Store Submission  
**Duration**: 5-7 business days (審査含)
