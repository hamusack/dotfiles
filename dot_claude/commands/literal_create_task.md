---
description: git issueを作成
---

# /create_task カスタムコマンドの目的と必要性

## 必要な理由

### 1. 効率的なスプリント管理の実現

- **現状の問題**: データチーム内での GitHub Issue 管理が統一されておらず、スプリント期間内で完了できない大きなタスクが散在
- **解決策**: スプリント期間内で完了可能なサイズに自動細分化し、適切な親子関係を設定

### 2. 統一された Issue 管理体系の確立

- **現状の問題**: ラベル体系やテンプレートが統一されておらず、タスクの追跡と管理が困難
- **解決策**: 標準化されたラベル体系（type/size/priority）と統一テンプレートの自動適用

### 3. 作業量の見える化と工数管理

- **現状の問題**: タスクの作業量が不明確で、適切な工数見積もりができない
- **解決策**: 5 段階のサイズ分類（XS/S/M/L/XL）による工数の明確化

## 目的

### 1. **効率的なスプリント管理**

- 全てのタスクをスプリント期間内で完了可能なサイズに自動細分化
- 親子関係を適切に設定し、エピック単位での進捗管理を実現

### 2. **統一された Issue 品質の確保**

- 標準テンプレートの自動適用による情報の統一化
- 適切なラベル付与による分類と検索性の向上

### 3. **作業効率の向上**

- Claude Code による自動判定で、手動での細分化作業を削減
- 確認観点の自動生成による完了判定の明確化

## 達成すべきこと

### 1. **自動細分化機能の実装**

- 大きなタスクをスプリント期間内対応サイズに自動分割
- 適切なラベル（type, size, priority）の自動付与
- 親子関係の自動設定
- Sub-issue 機能による階層構造の自動化
- GitHub Projects 連携の自動化（優先度・ボリューム設定）

### 2. **重みづけ機能の実装**

- 5 段階の重みづけを根拠と共に自動生成
- 工数見積もりの自動算出
- 依存関係の自動検出と明記

### 3. **テンプレート機能の統一**

- 親タスク・子タスクの統一テンプレート適用
- 確認観点の自動生成
- 目的とゴールの明確化

### 4. **運用品質の向上**

- 子タスクは独立して着手可能な単位に分割
- 確認観点を必ず設定し、完了判定を明確化
- 適切なラベルを漏れなく付与
- 親子関係を正しく設定
- 作成後の確認事項による設定漏れ防止

---

# 前提

- 以下の内容を元に、https://github.com/genda-tech/genda-data-pipeline へ MCP を使用して Issue を立ててください。
- 日本語で話してください。
- わからないことは必ず質問をしてください。
- 内容を考えた後はまずはコードブロックでチャット内に表示し、内容に問題ないかを必ず確認をしてください。
- Slack の URL や Confluence の URL を貼られた場合は MCP 経由で確認をしにいってください。

# 最初に以下を確認してください

## 1. 事前準備: 権限確認（必須）

- `gh auth status`で GitHub CLI 認証状態を確認
- 必要な権限が付与されているかを確認：
  - `repo` - Issue 作成・Sub-issue 登録に必要
  - `project` - GitHub Projects 連携に必要
  - `read:org` - 組織リポジトリアクセスに必要
- 権限不足の場合は以下で追加：
  ```bash
  gh auth refresh -s project
  ```

## 2. タスクの種類を選択してください：

- **A. 既存の親タスクに子タスクを追加**
- **B. 新しい親タスク**

# 重要な指示

## 作業フロー

1. **タスク種別選択**: A または B を選択
2. **A 選択時の処理**:
   - 親 Issue 番号を確認
   - MCP を使用して該当 Issue を読み込み
   - 親 Issue の内容を分析し、ultra think を使用して以下の情報を可能な限り推測・補完：
     - タスクの概要（親 Issue のタイトル・内容から推測）
     - 背景・現在の問題（親 Issue の説明から推測）
     - 依頼者（親 Issue の Assignee や作成者から推測）
     - 関連 Slack（親 Issue 内に Slack URL があれば MCP で内容確認）
     - 関連 Issue（親 Issue 内の参照から特定）
     - 期待される効果（親 Issue の内容から推測）
   - 過去の Issue に類似ケースがないかを MCP で検索・確認し、参考情報として活用
     - **注意**: 大量結果でエラーを避けるため、検索時は`per_page=5`で制限する
   - 上記で推測できない重要な情報のみをピンポイントでヒアリング
   - 親タスクから Assignees を取得
3. **B 選択時の処理**:
   - 実装内容をまず確認し、ultra think を使用して以下の情報を可能な限り推測・補完：
     - タスクの概要（実装内容から推測）
     - 背景・現在の問題（実装内容から推測）
     - 期待される効果（実装内容から推測）
   - 過去の Issue に類似ケースがないかを MCP で検索・確認し、参考情報として活用
     - **注意**: 大量結果でエラーを避けるため、検索時は`per_page=5`で制限する
   - 関連 Slack が提供された場合：
     - MCP を使用して Slack の内容を確認
     - 背景、依頼者、詳細な要求を読み取り
   - 関連 Issue が提供された場合：
     - MCP を使用して Issue の内容を確認
     - 背景、依頼者、関連情報を読み取り
   - 上記で推測できない重要な情報のみをピンポイントでヒアリング：
     - 依頼者（Slack や関連 Issue から特定できない場合）
     - Assignees（指定がない場合）
     - 不明確な実装詳細（実装内容が曖昧な場合）
   - 作業量を分析し、4 日を超える場合は子タスク化が必要と判定
   - 親タスクテンプレートを使用して内容を準備
   - 親タスクに type/epic ラベル、priority ラベルを付与予定
4. **共通処理: 子タスクの作業量見積もりと細分化**:
   - 収集・推測した情報から必要な子タスクを提案し、各子タスクの作業量を個別に見積もり：
     - 各子タスクは原則として 1 つあたり 4 日以内（size/L 以下）になるよう細分化
     - 各子タスクに適切な size ラベル（XS/S/M/L）を付与
     - 各子タスクに type/task ラベルを付与
     - 必要に応じて priority ラベルを付与
   - 子タスクテンプレートを使用して内容を準備
   - 子タスクタイトルに親 Issue 番号を含める（[#親 Issue 番号] 形式）
5. 準備した Issue 内容をコードブロックで表示し、確認を取る
6. **承認後に Issue を作成**：
   - A 選択時: 子タスクのみ作成
   - B 選択時: 親タスクと子タスクを作成
   - 子タスクには親タスクの Assignees を引き継ぎ
7. **Sub-issue 設定と親タスクの更新**：
   - 子タスクを Sub-issue として登録
   - 詳細は「GitHub 連携機能」セクションを参照
   - 親タスクを更新：
     - 子タスクのチェックリストを追加（- [ ] #[子 Issue 番号] 形式）
     - 親タスクに type/epic ラベルを付与
     - 親タスクに priority ラベルを付与
8. **GitHub Projects 連携（必須）**：
   - 作成した Issue（親・子タスク全て）を「GENDA DataTeam」プロジェクトに追加
   - 優先度・ボリュームフィールドを自動設定
   - 詳細は「GitHub 連携機能」セクションを参照
9. **作成後の確認（必須）**：
   - 「作成後の確認事項」セクションの全項目を実施
   - 特に以下の設定漏れがないか重点確認：
     - **GitHub Projects に追加されているか**
     - **プロジェクトの優先度フィールドが正しく設定されているか**
     - **プロジェクトのボリュームフィールドが正しく設定されているか**

# 作成後の確認事項

## 必須確認項目

- [ ] Issue が正常に作成されたか
- [ ] 適切なラベル（type/size/priority）が付与されているか
- [ ] Assignees が正しく設定されているか
- [ ] タイトル形式が正しいか
- [ ] **GitHub Projects に追加されているか**
- [ ] **プロジェクトの優先度フィールドが正しく設定されているか**
- [ ] **プロジェクトのボリュームフィールドが正しく設定されているか**

## 子タスク作成時の追加確認項目

- [ ] 親子関係が正しく設定されているか
- [ ] タイトルに[#親 Issue 番号]形式が含まれているか
- [ ] 親タスクの子タスクリストが更新されているか
- [ ] **全ての子タスクがプロジェクトに追加されているか**
- [ ] **子タスクのプロジェクトフィールドが親タスクと整合しているか**

## Sub-issue 機能利用時の追加確認項目

- [ ] **Sub-issue 関係が正常に設定されているか**
- [ ] **GitHub UI で階層構造が表示されているか**
- [ ] **親 Issue の進捗が自動計算されているか**
- [ ] **sub_issues_summary フィールドが更新されているか**

# テンプレート

## 親タスク（エピック）テンプレート

```markdown
### 概要（必須）

[タスクの概要を 1-2 文で記載]

### 背景・現在の問題（必須）

[なぜこのタスクが必要なのか、現在どのような問題があるのか]

### 詳細

#### 依頼者・関連情報（必須）

- 依頼者: @[GitHub ユーザー名]
- 関連 Slack: [Slack スレッドの URL]
- 関連 Confluence: [Confluence ページの URL]
- 関連 Issue: #[Issue 番号]

#### 実装内容（必須）

[具体的に何をするのか箇条書きで記載]

- [具体的な実装項目 1]
- [具体的な実装項目 2]
- [具体的な実装項目 3]

### 子タスク

- [ ] #[Issue 番号]
- [ ] #[Issue 番号]
- [ ] #[Issue 番号]

### 期待される効果（必須）

[このタスクを完了することで得られる効果]

### その他備考（任意）

[特記事項、注意点など]
```

## 子タスクテンプレート

```markdown
### 概要（必須）

[このタスクの概要を簡潔に記載]

### ゴール（必須）

[このタスクが完了した時の理想的な状態]

### タスク（必須）

- [ ] [具体的なタスク 1]
- [ ] [具体的なタスク 2]
- [ ] [具体的なタスク 3]

### 確認観点（必須）

- [完了判定のための確認項目 1]
- [完了判定のための確認項目 2]
- [完了判定のための確認項目 3]

### 依頼者・関連情報（必須）

- 依頼者: @[GitHub ユーザー名]
- Parent Issue: #[親 Issue 番号]
```

# ラベル付与ガイド

## A 選択時（子タスク）に付与するラベル

- `type/task` - 実作業単位のタスク
- `size/*` - 作業量に応じて以下から選択：
  - `size/XS` - 極小（1〜2 時間程度）
  - `size/S` - 小（半日〜1 日程度）
  - `size/M` - 中（1〜2 日程度）
  - `size/L` - 大（3〜4 日程度）
  - `size/XL` - 特大（5 日以上、必ず細分化が必要）
- `priority/*` - 優先度に応じて以下から選択：
  - `priority/P0` - 緊急（ブロッカー、今すぐ対応必要）
  - `priority/P1` - 高（このスプリントで必須）
  - `priority/P2` - 中（次のスプリントでも可）
  - `priority/P3` - 低（バックログ）

## B 選択時（親タスク）に付与するラベル

- `type/epic` - 大きなまとまり（エピック）
- `priority/*` - 優先度に応じて選択（上記と同じ）

## その他のラベル

- `type/bug` - バグ修正の場合
- `type/feature` - 新機能開発の場合

# タイトルの付け方パターン

1. 機能追加/改良: [コンポーネント名] 機能の説明

   - 例: Lambda 関数の改良: 複数 DB インスタンスのリストア・削除対応

2. バグ修正: [コンポーネント名] #関連 Issue 番号 バグの説明

   - 例: [Braze] #469 GOC 日次ユーザー属性の SQL バグ修正

3. 連携作業: [連携名] タスクの説明

   - 例: [SHIN] Braze テーブル連携 USERS_CANVAS_EXPERIMENTSTEP_SPLITENTRY_SHARED

4. サブタスク: [#親 Issue 番号] サブタスクの説明
   - 例: [#618] 運用ガイドの内容レビューと合意形成

# GitHub 連携機能

## GitHub Projects 連携

### プロジェクト情報

- **プロジェクト名**: GENDA DataTeam
- **プロジェクト ID**: PVT_kwDOBjKQHs4AypX9
- **URL**: https://github.com/orgs/genda-tech/projects/5

### 自動設定内容

- **優先度フィールド**: priority ラベル → 「優先度」フィールド
- **ボリュームフィールド**: size ラベル → 「ボリューム」フィールド

### 実装方法

```bash
# 1. Projectに追加してIDを直接取得
ITEM_ID=$(gh project item-add 5 --owner genda-tech --url https://github.com/genda-tech/genda-data-pipeline/issues/{issue_number} --format json | jq -r '.id')

# 2. プロジェクトAPI同期待機
sleep 2

# 3. 優先度設定
gh project item-edit --id $ITEM_ID \
  --field-id PVTSSF_lADOBjKQHs4AypX9zgokNOc \
  --project-id PVT_kwDOBjKQHs4AypX9 \
  --single-select-option-id {priority_option_id}

# 4. ボリューム設定
gh project item-edit --id $ITEM_ID \
  --field-id PVTSSF_lADOBjKQHs4AypX9zgokNOg \
  --project-id PVT_kwDOBjKQHs4AypX9 \
  --single-select-option-id {size_option_id}
```

### ラベルとオプション ID の対応

#### 優先度フィールド（PVTSSF_lADOBjKQHs4AypX9zgokNOc）

- `priority/P0` → 648549b6 (最優先 🔴)
- `priority/P1` → 57462762 (優先 🟠)
- `priority/P2` → dab6fb0b (通常 🟡)
- `priority/P3` → 7795d1ca (優先度低 🔵)

#### ボリュームフィールド（PVTSSF_lADOBjKQHs4AypX9zgokNOg）

- `size/XS` → 24c8b56e (0D - 極小 1〜2 時間程度)
- `size/S` → 6445d5d5 (1D - 小 半日〜1 日程度)
- `size/M` → 53fe0742 (3D - 中 1〜2 日程度)
- `size/L` → c532640a (1W - 大 3〜4 日程度)
- `size/XL` → 7b827832 (2W - 特大 5 日以上)

### 実行例（Issue #628 の場合）

```bash
# 1. Projectに追加してIDを直接取得
ITEM_ID=$(gh project item-add 5 --owner genda-tech --url https://github.com/genda-tech/genda-data-pipeline/issues/628 --format json | jq -r '.id')

# 2. プロジェクトAPI同期待機
sleep 2

# 3. 優先度設定（P1）
gh project item-edit --id $ITEM_ID \
  --field-id PVTSSF_lADOBjKQHs4AypX9zgokNOc \
  --project-id PVT_kwDOBjKQHs4AypX9 \
  --single-select-option-id 57462762

# 4. ボリューム設定（XL）
gh project item-edit --id $ITEM_ID \
  --field-id PVTSSF_lADOBjKQHs4AypX9zgokNOg \
  --project-id PVT_kwDOBjKQHs4AypX9 \
  --single-select-option-id 7b827832
```

### 一括処理用スクリプト例

```bash
# 複数Issueの一括処理
for issue_num in 657 658 659 660 661; do
  echo "Processing Issue #$issue_num"
  ITEM_ID=$(gh project item-add 5 --owner genda-tech --url https://github.com/genda-tech/genda-data-pipeline/issues/$issue_num --format json | jq -r '.id')
  sleep 2

  # 優先度設定（P3）
  gh project item-edit --id $ITEM_ID \
    --field-id PVTSSF_lADOBjKQHs4AypX9zgokNOc \
    --project-id PVT_kwDOBjKQHs4AypX9 \
    --single-select-option-id 7795d1ca

  # ボリューム設定（issue番号に応じて分岐）
  if [[ $issue_num == 658 || $issue_num == 659 ]]; then
    # size/M
    gh project item-edit --id $ITEM_ID \
      --field-id PVTSSF_lADOBjKQHs4AypX9zgokNOg \
      --project-id PVT_kwDOBjKQHs4AypX9 \
      --single-select-option-id 53fe0742
  elif [[ $issue_num == 660 ]]; then
    # size/L
    gh project item-edit --id $ITEM_ID \
      --field-id PVTSSF_lADOBjKQHs4AypX9zgokNOg \
      --project-id PVT_kwDOBjKQHs4AypX9 \
      --single-select-option-id c532640a
  elif [[ $issue_num == 661 ]]; then
    # size/S
    gh project item-edit --id $ITEM_ID \
      --field-id PVTSSF_lADOBjKQHs4AypX9zgokNOg \
      --project-id PVT_kwDOBjKQHs4AypX9 \
      --single-select-option-id 6445d5d5
  fi

  echo "Issue #$issue_num completed"
done
```

## Sub-issue 機能

### 利点

- **自動進捗計算**: 子タスクの完了状況が親 Issue に自動反映
- **視覚的階層表示**: GitHub UI で親子関係が分かりやすく表示
- **検索性向上**: `has:sub-issues`などの専用フィルターが利用可能

### 実装方法

```bash
# Sub-issue登録
gh api -X POST repos/genda-tech/genda-data-pipeline/issues/{parent_issue_number}/sub_issues \
  -F sub_issue_id={child_issue_internal_id}

# Issue内部IDの取得
# MCPでIssue詳細を取得し、レスポンスの"id"フィールドを使用
```

# エラーハンドリング

## GitHub CLI 認証エラーの場合

- `gh auth status`で認証状態を確認してください
- 未認証の場合は`gh auth login`で認証を実行してください
- 権限不足の場合は以下で必要な権限を追加してください：
  ```bash
  gh auth refresh -s project
  ```
- 認証後は再度`gh auth status`で権限を確認してください

## MCP 接続エラーの場合

- GitHub API の認証状態を確認してください
- 再試行後も失敗する場合は、一時的に手動での Issue 作成に切り替えてください

## Issue 作成失敗の場合

- リポジトリへの書き込み権限を確認してください
- テンプレート形式やラベル名を再確認してください
- 親 Issue が存在しない場合は、まず親 Issue の作成から開始してください

## Sub-issue 登録エラーの場合

- Issue 内部 ID が正しいか確認してください（node_id ではなく、数値の id を使用）
- 親 Issue が存在し、アクセス権限があるか確認してください
- `repo`権限が付与されているか確認してください

## GitHub Projects 連携エラーの場合

- `project`権限が付与されているか確認してください
- Project ID（PVT_kwDOBjKQHs4AypX9）が正しいか確認してください
- Field ID（優先度・ボリューム）が正しいか確認してください
- Option ID（P0-P3、XS-XL）が正しいか確認してください
- プロジェクトアイテムの追加後、フィールド設定まで数秒待機する
- ITEM_ID が空の場合は、gh project item-add の戻り値から直接 ID を取得する
- 環境変数が正しく設定されているか確認する
- gh project item-add 実行時に--format json オプションを必ず指定する

## 情報取得エラーの場合

- 関連 Slack の URL が無効な場合は、手動で背景情報をヒアリングしてください
- 関連 Issue が見つからない場合は、Issue 番号を再確認してください
- 過去の類似ケース検索で結果が見つからない場合は、通常通り処理を継続してください
- **検索結果が大量すぎる場合**: MCP のトークン制限エラーを避けるため、`per_page=5`で結果を制限する