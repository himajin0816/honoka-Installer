# アセンブリの読み込み
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

# フォームの設定
$form = New-Object System.Windows.Forms.Form
$form.Size = New-Object System.Drawing.Size(700,500)
# フォームの表示場所設定
$form.StartPosition = "CenterScreen"
$version = "0.1.0"
$form.Text = "凪咲ほのか セットアップ Ver "+$version
$form.MaximizeBox = $False  # 最大化ボタン非表示
$form.MinimizeBox = $False  # 最少化ボタン非表示
$form.FormBorderStyle = "FixedSingle"   # ウィンドウスタイル指定
$form.Opacity = 1

# アイコン設定
# $form.Icon = $PSScriptRoot+"C:\Pictures\TAKE.ico"
# 背景画像設定
$imagePath = $PSScriptRoot + "\background.png"
$form.BackgroundImage = [system.drawing.image]::FromFile($imagePath)

# フォントの設定
$Font = New-Object System.Drawing.Font("Yu Gothic UI",14,[System.Drawing.FontStyle]::Bold)

# ボタン設定
$margin = 40
$button_x = $form.Size.Width / 2 + $margin
$button_w = 245
$button_h = 40
$button_color = "LightSlateGray"
Set-Variable -Scope script -Name installFlag -Value $false

# インストールボタン
$buttonInstall = New-Object System.Windows.Forms.Button
$buttonInstall.Location = New-Object System.Drawing.Point($button_x, 80)
$buttonInstall.Size = New-Object System.Drawing.Size($button_w ,80)
$buttonInstall.Text = 'Install'
$buttonInstall.Font = New-Object System.Drawing.Font("Yu Gothic UI",50)
# $buttonInstall.Flatstyle = "Popup"
$buttonInstall.backcolor = $button_color
$buttonInstall.forecolor = "White"
$buttonInstall.Add_Click({
    if ($script:installFlag -eq $false) {
        $script:installFlag = $true
        [void] $formInstall.ShowDialog()
        # [System.Windows.Forms.MessageBox]::Show("nullをインストールしました。")
    }else {
        [System.Windows.Forms.MessageBox]::Show("既にインストールされています。")
    }
    
})

# アクティベートボタン
$buttonActivate = New-Object System.Windows.Forms.Button
$buttonActivate.Location = New-Object System.Drawing.Point($button_x, 187)
$buttonActivate.Size = New-Object System.Drawing.Size($button_w ,$button_h)
# $buttonActivate.Size = New-Object System.Drawing.
$buttonActivate.Text = 'オフラインアクティベーション'
$buttonActivate.Font = $Font
$buttonActivate.backcolor = $button_color
$buttonActivate.forecolor = "White"
$buttonActivate.Add_Click({[System.Windows.Forms.MessageBox]::Show("工事中")})

# 公式サイトリンク
$buttonTwitter = New-Object System.Windows.Forms.Button
$buttonTwitter.Location = New-Object System.Drawing.Point($button_x, 255)
$buttonTwitter.Size = New-Object System.Drawing.Size($button_w ,$button_h)
# $buttonTwitter.Size = New-Object System.Drawing.
$buttonTwitter.Text = '公式Twitter'
$buttonTwitter.Font = $Font
$buttonTwitter.backcolor = $button_color
$buttonTwitter.forecolor = "White"
$buttonTwitter.Add_Click({start ‘https://twitter.com/nagisakihonoka’})

# 終了ボタン
$buttonExit = New-Object System.Windows.Forms.Button
$buttonExit.Location = New-Object System.Drawing.Point($button_x, 373)
$buttonExit.Size = New-Object System.Drawing.Size($button_w ,$button_h)
# $buttonExit.Size = New-Object System.Drawing.
$buttonExit.Text = 'インストーラーを終了する'
$buttonExit.Font = $Font
$buttonExit.backcolor = $button_color
$buttonExit.forecolor = "White"
$buttonExit.Add_Click({
    $wsobj = new-object -comobject wscript.shell
    $result = $wsobj.popup("インストーラーを終了します。",0,"メッセージ",1)
    # Write-Host $result
    if ($result -eq 1){
        $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        $form.Close()
    }
})

# Installフォームの設定
$formInstall = New-Object System.Windows.Forms.Form
$formInstall.Size = New-Object System.Drawing.Size(400,200)
$formInstall.StartPosition = "CenterScreen"
$formInstall.Text = "インストール"
$formInstall.MaximizeBox = $False   # 最大化ボタン非表示
$formInstall.MinimizeBox = $False   # 最少化ボタン非表示
$formInstall.FormBorderStyle = "FixedSingle"   # ウィンドウスタイル指定
$formInstall.Opacity = 1
$formInstall.Owner = $form
# プログレスバー
$Bar = New-Object System.Windows.Forms.ProgressBar
$Bar.Location = "10,30"
$Bar.Size = "360,30"
$Bar.Maximum = "100"
$Bar.Minimum = "0"
$Bar.Style = "Continuous"
$formInstall.Controls.Add($Bar)
$formInstall.Add_Shown({
    $formInstall.Activate()
    Start-Sleep -Seconds 2
    For ( $i = 0 ; $i -lt 100 ; $i++ )
    {
        $Bar.Value = $i+1
        start-sleep -s 0.5
    }
    $wsobj = new-object -comobject wscript.shell
    $result = $wsobj.popup("nullをインストールしました。",0,"メッセージ",64)
    if ($result -eq 1){
        $formInstall.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        $formInstall.Close()
    }
})

#ボタンをフォームに紐づける。
$form.Controls.Add($buttonInstall)
$form.Controls.Add($buttonActivate)
$form.Controls.Add($buttonTwitter)
$form.Controls.Add($buttonExit)

#フォームの表示
$form.Add_Shown({$form.Activate()})
[void] $form.ShowDialog()