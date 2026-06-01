param(
    [ValidateSet('A', 'B', 'C', 'D')]
    [string]$Phase
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$archive = Join-Path $root '格子档案'
$task = Join-Path $root 'tasks\TASK-003-批量灌122家.md'
$utf8 = New-Object System.Text.UTF8Encoding($false)

function Write-Utf8([string]$Path, [string]$Content) {
    [System.IO.File]::WriteAllText($Path, $Content, $utf8)
}

function Clean([string]$Value) {
    return ($Value -replace '\*\*', '').Trim()
}

function Read-Rows {
    $paths = @(
        (Join-Path $root '数据源\report.md'),
        (Join-Path $root '数据源\report_51_100.md'),
        (Join-Path $root '数据源\report_101_150.md')
    )
    $rows = foreach ($path in $paths) {
        foreach ($line in [System.IO.File]::ReadAllLines($path, $utf8)) {
            if ($line -match '^\|\s*\**(\d+)\**\s*\|') {
                $parts = $line.Split('|')
                [pscustomobject]@{
                    Rank = [int](Clean $parts[1])
                    Company = Clean $parts[2]
                    Country = Clean $parts[3]
                    Track = Clean $parts[4]
                    Arr = Clean $parts[5]
                    Valuation = Clean $parts[6]
                    Growth = Clean $parts[7]
                }
            }
        }
    }
    return @($rows | Sort-Object Rank)
}

$defs = @(
    [pscustomobject]@{ Id='CELL-001'; Slug='agent可靠性'; Title='agent 可靠性跨阈值 × L3 系统集成 × 左上'; Layer='L3'; Quadrant='明牌-技术锁'; Step='agent 自主多步执行的可靠性、eval 与交付跨阈值'; Members=@('Cursor','Lovable','Decagon','Fireflies.ai','Emergent','Replit','Harvey AI','Phind','Copy.ai','Instabase','Sourcegraph','Moveworks','Clio','Writer') },
    [pscustomobject]@{ Id='CELL-002'; Slug='大模型能力'; Title='大模型能力跃迁 × L1 核心突破 × 左上'; Layer='L1'; Quadrant='明牌-技术锁'; Step='预训练、推理与多模态能力在规模化算力上持续跃迁'; Members=@('Anthropic','OpenAI','Mistral AI','Kimi (Moonshot AI)','xAI','DeepSeek','MiniMax','Zhipu AI','Cohere AI','01.AI (零一万物)','Baichuan (百川智能)') },
    [pscustomobject]@{ Id='CELL-003'; Slug='答案式搜索'; Title='答案式搜索 × L4 体验重塑 × 左上'; Layer='L4'; Quadrant='明牌-技术锁'; Step='联网检索、引用归因与生成式回答组合成可用搜索体验'; Members=@('Perplexity AI') },
    [pscustomobject]@{ Id='CELL-004'; Slug='生成式媒体'; Title='生成式媒体 × L4 体验重塑 × 左上'; Layer='L4'; Quadrant='明牌-技术锁'; Step='图像、语音与视频生成质量跨过专业创作可用阈值'; Members=@('Midjourney','ElevenLabs','Runway ML') },
    [pscustomobject]@{ Id='CELL-005'; Slug='AI数据与工具链'; Title='AI 数据与工具链 × L2 使能设施 × 左上'; Layer='L2'; Quadrant='明牌-技术锁'; Step='模型应用规模化后，数据、检索、编排、部署与可观测性成为共用设施'; Members=@('Databricks','Scale AI','Hugging Face','Supabase','LangChain','Pinecone','Vercel','OctoML','Weights & Biases','Fivetran','dbt Labs','Anyscale','Temporal Technologies','Confluent','GitLab','Rescale') },
    [pscustomobject]@{ Id='CELL-006'; Slug='网络信任自动化'; Title='网络信任自动化 × L3 系统集成 × 左上'; Layer='L3'; Quadrant='明牌-技术锁'; Step='云化与攻击面扩张使持续检测、合规取证和风险识别必须自动化'; Members=@('Wiz','Netradyne','Abnormal Security','Drata','Vanta','Chainalysis','Snyk') },
    [pscustomobject]@{ Id='CELL-007'; Slug='数字支付轨道'; Title='数字支付轨道 × L2 使能设施 × 左上'; Layer='L2'; Quadrant='明牌-技术锁'; Step='移动支付、API 银行与跨境牌照网络把资金流转基础设施化'; Members=@('Stripe','PhonePe','Plaid','Razorpay','Airwallex','Rapyd') },
    [pscustomobject]@{ Id='CELL-008'; Slug='金融运营数字化'; Title='金融运营数字化 × L3 系统集成 × 左上'; Layer='L3'; Quadrant='明牌-技术锁'; Step='支付轨道成熟后，企业与个人财务流程可被软件完整封装'; Members=@('Ramp','Moniepoint','Brex','Klarna','CRED','Mercury','Cleo') },
    [pscustomobject]@{ Id='CELL-009'; Slug='消费IP全球化'; Title='消费 IP 全球化 × L4 体验重塑 × 右上'; Layer='L4'; Quadrant='暗牌-技术锁'; Step='全球供应链、社交传播与线下网络让本土审美 IP 可跨地域放大'; Members=@('Pop Mart','Miniso') },
    [pscustomobject]@{ Id='CELL-010'; Slug='新兴市场零售网络'; Title='新兴市场零售网络 × L3 系统集成 × 左上'; Layer='L3'; Quadrant='明牌-技术锁'; Step='移动互联网、数字支付与仓配网络开始覆盖碎片化零售'; Members=@('Omniretail','Drools','Meesho','Jumbotail') },
    [pscustomobject]@{ Id='CELL-011'; Slug='数字医疗服务'; Title='数字医疗服务 × L3 系统集成 × 左上'; Layer='L3'; Quadrant='明牌-技术锁'; Step='远程服务、支付与药品履约基础设施允许医疗流程线上闭环'; Members=@('ABA Centers','Babylon Health','Weave','Devoted Health','Hims & Hers','Capsule Pharmacy') },
    [pscustomobject]@{ Id='CELL-012'; Slug='生物数据化'; Title='生物数据化 × L3 系统集成 × 左上'; Layer='L3'; Quadrant='明牌-技术锁'; Step='测序、实验自动化与计算建模让生物研发形成数据闭环'; Members=@('Colossal Biosciences','Insitro','Moderna (Diagnostics)','Recursion Pharma','Benchling','Sema4') },
    [pscustomobject]@{ Id='CELL-013'; Slug='协作工作流'; Title='协作工作流 × L3 系统集成 × 左上'; Layer='L3'; Quadrant='明牌-技术锁'; Step='云端协作成为默认行为，知识工作流程可被软件持续承载'; Members=@('Notion','Airtable','Linear','Miro','Calendly','Loom','Bizzabo') },
    [pscustomobject]@{ Id='CELL-014'; Slug='创作民主化'; Title='创作民主化 × L3 系统集成 × 左上'; Layer='L3'; Quadrant='明牌-技术锁'; Step='浏览器图形能力与协作基础设施把专业创作工具下放给更广人群'; Members=@('Figma','Canva') },
    [pscustomobject]@{ Id='CELL-015'; Slug='人力流程数字化'; Title='人力流程数字化 × L3 系统集成 × 左上'; Layer='L3'; Quadrant='明牌-技术锁'; Step='远程协作、身份数据与合规接口让人力流程可端到端软件化'; Members=@('Deel','Gusto','Personio','Checkr','Turing') },
    [pscustomobject]@{ Id='CELL-016'; Slug='工业脱碳'; Title='工业脱碳 × L3 系统集成 × 左上'; Layer='L3'; Quadrant='明牌-技术锁'; Step='政策约束与工程成本曲线让低碳材料、燃料和储能开始商业化'; Members=@('Twelve','Heirloom','Sublime Systems','Rondo Energy','Motif FoodWorks') },
    [pscustomobject]@{ Id='CELL-017'; Slug='碳数据可信化'; Title='碳数据可信化 × L3 系统集成 × 左上'; Layer='L3'; Quadrant='明牌-技术锁'; Step='碳市场扩张后，项目质量评级与监测核验成为必要设施'; Members=@('BeZero Carbon','Sylvera') },
    [pscustomobject]@{ Id='CELL-018'; Slug='零售运营重构'; Title='零售运营重构 × L3 系统集成 × 左上'; Layer='L3'; Quadrant='明牌-技术锁'; Step='移动点单、供应链数据与门店数字化允许高频零售重构运营'; Members=@('Luckin Coffee') },
    [pscustomobject]@{ Id='CELL-019'; Slug='物流网络数字化'; Title='物流网络数字化 × L3 系统集成 × 左上'; Layer='L3'; Quadrant='明牌-技术锁'; Step='移动调度、实时追踪与数字单据让复杂物流网络在线化'; Members=@('Porter','Flexport') },
    [pscustomobject]@{ Id='CELL-020'; Slug='企业流程软件化'; Title='企业流程软件化 × L3 系统集成 × 左上'; Layer='L3'; Quadrant='明牌-技术锁'; Step='SaaS 接口普及后，销售、运营和内部工具流程可被持续编排'; Members=@('Gong','UIPath','Celonis','Retool','Podium','Webflow') },
    [pscustomobject]@{ Id='CELL-021'; Slug='自主移动系统'; Title='自主移动系统 × L3 系统集成 × 左上'; Layer='L3'; Quadrant='明牌-技术锁'; Step='感知、规划、硬件成本与监管试点让有限场景自主移动可运营'; Members=@('Aurora','Nuro','Zipline') },
    [pscustomobject]@{ Id='CELL-022'; Slug='室内农业'; Title='室内农业 × L3 系统集成 × 左上'; Layer='L3'; Quadrant='明牌-技术锁'; Step='传感器、自动化与受控环境工程试图把农业生产工业化'; Members=@('Plenty','Infarm') },
    [pscustomobject]@{ Id='CELL-023'; Slug='软件定义国防'; Title='软件定义国防 × L3 系统集成 × 左上'; Layer='L3'; Quadrant='明牌-技术锁'; Step='传感器、自治软件与模块化硬件允许国防系统快速迭代'; Members=@('Anduril Industries') },
    [pscustomobject]@{ Id='CELL-024'; Slug='在线教育匹配'; Title='在线教育匹配 × L3 系统集成 × 左上'; Layer='L3'; Quadrant='明牌-技术锁'; Step='视频、支付与跨境匹配降低个性化教学的交付成本'; Members=@('Preply') },
    [pscustomobject]@{ Id='CELL-025'; Slug='可复用发射'; Title='可复用发射 × L1 核心突破 × 左上'; Layer='L1'; Quadrant='明牌-技术锁'; Step='材料、制造与发射工程迭代持续压低进入轨道的成本'; Members=@('Relativity Space') },
    [pscustomobject]@{ Id='CELL-026'; Slug='AI陪伴'; Title='AI 陪伴 × L4 体验重塑 × 右上'; Layer='L4'; Quadrant='暗牌-技术锁'; Step='对话模型的角色一致性与低延迟交互让持续陪伴体验第一次可用'; Members=@('Character.ai') }
)

$rows = Read-Rows
$rowByCompany = @{}
foreach ($row in $rows) {
    if ($rowByCompany.ContainsKey($row.Company)) { throw "重复公司：$($row.Company)" }
    $rowByCompany[$row.Company] = $row
}

$defByCompany = @{}
foreach ($def in $defs) {
    foreach ($company in $def.Members) {
        if ($defByCompany.ContainsKey($company)) { throw "重复归格：$company" }
        $defByCompany[$company] = $def
    }
}

if ($rows.Count -ne 122) { throw "数据源应为 122 行，实际为 $($rows.Count)" }
$missing = @($rows | Where-Object { -not $defByCompany.ContainsKey($_.Company) })
$unknown = @($defByCompany.Keys | Where-Object { -not $rowByCompany.ContainsKey($_) })
if ($missing.Count -or $unknown.Count) {
    throw "归格校验失败。未归格：$($missing.Company -join ', ')；映射中不存在：$($unknown -join ', ')"
}

function Region-State($def, [string]$Region) {
    $members = @($def.Members | ForEach-Object { $rowByCompany[$_] })
    if (@($members | Where-Object { $_.Country -match $Region }).Count) { return '满' }
    return '空'
}

function Initial-Type($def) {
    $us = Region-State $def '美国'
    $cn = Region-State $def '中国'
    if ($us -eq '满' -and $cn -eq '满') { return '已踩热' }
    if ($us -eq '满' -and $cn -eq '空') { return '对标候选' }
    return '观察'
}

function Data-Text($row) {
    return "ARR $($row.Arr) / 估值 $($row.Valuation) / 增速 $($row.Growth)"
}

function New-Total([bool]$IncludeCells) {
    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('# 122 家高增长公司 · 分类总表')
    $lines.Add('')
    $lines.Add('> 数据源：`数据源/report.md`、`数据源/report_51_100.md`、`数据源/report_101_150.md`。')
    $lines.Add('> 口径：本表只做幸存者分类，不构成结构验证。报告数据多为第三方估算，统一标 `C`；象限是墓碑研究前的假设。')
    $lines.Add('')
    if ($IncludeCells) {
        $lines.Add('| 公司 | 国家 | 赛道 | 层(L1-4) | 踏脚石(什么刚翻转让它此刻可能) | 需求象限(明/暗×技/羞) | 数据(ARR/估值/增速) | 证据级 | 格子ID |')
        $lines.Add('|---|---|---|---|---|---|---|---|---|')
    } else {
        $lines.Add('| 公司 | 国家 | 赛道 | 层(L1-4) | 踏脚石(什么刚翻转让它此刻可能) | 需求象限(明/暗×技/羞) | 数据(ARR/估值/增速) | 证据级 |')
        $lines.Add('|---|---|---|---|---|---|---|---|')
    }
    foreach ($row in $rows) {
        $def = $defByCompany[$row.Company]
        $parts = @($row.Company, $row.Country, $row.Track, $def.Layer, $def.Step, "$($def.Quadrant)（假设）", (Data-Text $row), 'C')
        if ($IncludeCells) { $parts += $def.Id }
        $lines.Add('| ' + ($parts -join ' | ') + ' |')
    }
    if ($IncludeCells) {
        $lines.Add('')
        $lines.Add('## 格子清单')
        $lines.Add('')
        $lines.Add('> 初判类型来自幸存者地域读数。幸存者表不能直接产出「全球空」格，因此本轮不强造奇点候选。')
        $lines.Add('')
        $lines.Add('| 格子ID | 踏脚石×层×象限 | 成员公司 | 美国(满/空) | 中国(满/空) | 初判类型 |')
        $lines.Add('|---|---|---|---|---|---|')
        foreach ($def in $defs) {
            $lines.Add("| $($def.Id) | $($def.Step) × $($def.Layer) × $($def.Quadrant)（假设） | $($def.Members -join '、') | $(Region-State $def '美国') | $(Region-State $def '中国') | $(Initial-Type $def) |")
        }
    }
    Write-Utf8 (Join-Path $archive '_分类总表.md') (($lines -join "`n") + "`n")
}

function New-Skeletons {
    foreach ($def in @($defs | Where-Object { $_.Id -ne 'CELL-001' })) {
        $us = (Region-State $def '美国').ToLower().Replace('满', 'full').Replace('空', 'empty')
        $cn = (Region-State $def '中国').ToLower().Replace('满', 'full').Replace('空', 'empty')
        $quadSlug = if ($def.Quadrant -eq '明牌-技术锁') { '左上' } elseif ($def.Quadrant -eq '暗牌-技术锁') { '右上' } elseif ($def.Quadrant -eq '明牌-羞耻锁') { '左下' } else { '右下' }
        $path = Join-Path $archive "$($def.Id)-$($def.Slug)-$($def.Layer)-$quadSlug.md"
        $lines = [System.Collections.Generic.List[string]]::new()
        $lines.Add('---')
        $lines.Add("id: $($def.Id)")
        $lines.Add("title: $($def.Title)")
        $lines.Add("layer: $($def.Layer)")
        $lines.Add("region_us: $us")
        $lines.Add("region_cn: $cn")
        $lines.Add("demand_quadrant: $($def.Quadrant)")
        $lines.Add('redline: false')
        $lines.Add('status: open')
        $lines.Add('evidence: C')
        $lines.Add('updated: 2026-05-31')
        $lines.Add('---')
        $lines.Add('')
        $lines.Add("# $($def.Title)")
        $lines.Add('')
        $lines.Add('## 踏脚石（铁律一：分析单元）')
        $lines.Add($def.Step)
        $lines.Add('')
        $lines.Add('## 站在格子里的活公司')
        $lines.Add('| 公司 | 国家 | 一句话定位 | 数据(ARR/估值/增速) | 证据级 |')
        $lines.Add('|---|---|---|---|---|')
        foreach ($company in $def.Members) {
            $row = $rowByCompany[$company]
            $lines.Add("| $($row.Company) | $($row.Country) | $($row.Track) | $(Data-Text $row) | C |")
        }
        $lines.Add('')
        $lines.Add('## 墓碑（铁律二：无墓碑不入档）')
        $lines.Add('> 待补墓碑（铁律二）：本格暂不合格，墓碑研究见优先级队列。')
        $lines.Add('')
        $lines.Add('**生死比读数：** 待补墓碑后计算。')
        $lines.Add('')
        $lines.Add('## 邻近空格（引擎产出）')
        $lines.Add('（待墓碑补全后填）')
        $lines.Add('')
        $lines.Add('## 中国读数')
        $lines.Add("美国此格$(Region-State $def '美国')，中国此格$(Region-State $def '中国')。当前初判：$(Initial-Type $def)。本格尚缺墓碑，不作为预测依据。")
        $lines.Add('')
        $lines.Add('## 机制提炼（可迁移到其它格子的那条规律）')
        $lines.Add('（待墓碑补全后填）')
        Write-Utf8 $path (($lines -join "`n") + "`n")
    }
}

function New-Queue {
    $ordered = @($defs | Where-Object { $_.Id -ne 'CELL-001' } | Sort-Object @{ Expression = {
        $type = Initial-Type $_
        if ($type -eq '对标候选') { 1 } elseif ($type -eq '已踩热') { 2 } else { 3 }
    } }, @{ Expression = {
        if ($_.Layer -eq 'L4') { 1 } elseif ($_.Layer -eq 'L2') { 2 } elseif ($_.Layer -eq 'L1') { 3 } else { 4 }
    } }, Id)
    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('# 墓碑研究优先级队列')
    $lines.Add('')
    $lines.Add('> 版本：v1.0 · 2026-05-31')
    $lines.Add('> 本队列来自 122 家幸存者分类。所有条目均为 `status: open` 的待验证骨架，不是预测。')
    $lines.Add('> 本轮数据无法直接产出「全球空」格，因此没有强造奇点候选；排序从对标候选开始，其次为已踩热与观察格。')
    $lines.Add('')
    $lines.Add('| 顺位 | 格子ID | 初判类型 | 为什么排在这里 | 墓碑研究问题 |')
    $lines.Add('|---:|---|---|---|---|')
    $i = 1
    foreach ($def in $ordered) {
        $type = Initial-Type $def
        if ($type -eq '对标候选') {
            $why = '美国已有幸存者、中国未见成员；先用墓碑检验结构能否跨地域成立'
        } elseif ($type -eq '已踩热') {
            $why = '中美均有幸存者；记录价值高，但不优先外推空格'
        } else {
            $why = '幸存者地域读数不足；先补墓碑，再决定是否值得继续观察'
        }
        $question = "2020–2025 年押注「$($def.Step)」且拿过融资或有明显声量、但已关停、贱卖、衰退或放弃原方向的公司有哪些？共同死法是什么？"
        $lines.Add("| $i | $($def.Id) | $type | $why | $question |")
        $i++
    }
    Write-Utf8 (Join-Path $root 'tasks\墓碑研究队列.md') (($lines -join "`n") + "`n")
}

function Add-ExecutionRecord {
    $content = [System.IO.File]::ReadAllText($task, $utf8)
    if ($content -match '(?m)^## 执行记录\s*$') { return }
    $record = @'

## 执行记录
执行于 2026-05-31。三份数据源共提取 122 家幸存者，全部完成三轴假设归位，聚为 26 个格子（含既有 CELL-001；新建 CELL-002 至 CELL-026）。

本轮没有奇点候选。原因不是奇点不存在，而是输入表只包含幸存公司，无法直接产出「全球空 + 邻近格已点亮」的格子；为遵守铁律二，不凭直觉强造。

成员最多的踏脚石格是 CELL-005「AI 数据与工具链」（16 家），其次是 CELL-001「agent 可靠性」（14 家），两者是本轮最拥挤的区域。中国空得最干净、且美国已有成员的格子不止一个；其中优先研究 CELL-003「答案式搜索」、CELL-004「生成式媒体」和 CELL-026「AI 陪伴」三个 L4 格，再看 CELL-005 等基础设施格。后续逐格补墓碑后再判断对标价值。
'@
    [System.IO.File]::AppendAllText($task, $record, $utf8)
}

switch ($Phase) {
    'A' { New-Total $false }
    'B' { New-Total $true }
    'C' { New-Skeletons }
    'D' { New-Queue; Add-ExecutionRecord }
}

Write-Host "TASK-003 phase $Phase complete: $($rows.Count) companies, $($defs.Count) cells."
