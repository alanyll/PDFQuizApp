#!/bin/bash
# ============================================================
# PDFQuizApp IPA 构建脚本
# 在 macOS 上运行此脚本即可一键生成 .ipa 安装包
# ============================================================
set -e

APP_NAME="PDF答题助手"
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
DERIVED_DATA="$PROJECT_DIR/.build"
ARCHIVE_PATH="$PROJECT_DIR/Archive.xcarchive"
IPA_DIR="$PROJECT_DIR/IPA"
SCHEME="PDFQuizApp"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  ${APP_NAME} - IPA 构建工具${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# 步骤1: 检查环境
echo -e "${YELLOW}[1/6] 检查构建环境...${NC}"

if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}错误: 未找到 xcodebuild，请安装 Xcode${NC}"
    exit 1
fi

XCODE_VERSION=$(xcodebuild -version | head -n 1)
echo "  ✓ $XCODE_VERSION"

# 步骤2: 安装 xcodegen（如果没有）
if ! command -v xcodegen &> /dev/null; then
    echo "  正在安装 xcodegen..."
    brew install xcodegen 2>/dev/null || {
        echo -e "${RED}错误: 请先安装 Homebrew (https://brew.sh)，然后重试${NC}"
        exit 1
    }
fi
echo "  ✓ xcodegen 已就绪"

# 步骤3: 生成 Xcode 项目
echo -e "${YELLOW}[2/6] 生成 Xcode 项目...${NC}"
cd "$PROJECT_DIR"
xcodegen generate
echo "  ✓ Xcode 项目已生成"

# 步骤4: 清理
echo -e "${YELLOW}[3/6] 清理旧构建...${NC}"
rm -rf "$DERIVED_DATA" "$ARCHIVE_PATH" "$IPA_DIR"
mkdir -p "$IPA_DIR"
echo "  ✓ 清理完成"

# 步骤5: 归档
echo -e "${YELLOW}[4/6] 编译并归档 (Archive)...${NC}"
xcodebuild archive \
    -project "$PROJECT_DIR/PDFQuizApp.xcodeproj" \
    -scheme "$SCHEME" \
    -configuration Release \
    -destination "generic/platform=iOS" \
    -derivedDataPath "$DERIVED_DATA" \
    -archivePath "$ARCHIVE_PATH" \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO \
    DEVELOPMENT_TEAM="" \
    2>&1 | tail -5

if [ ! -d "$ARCHIVE_PATH" ]; then
    echo -e "${RED}错误: 归档失败${NC}"
    exit 1
fi
echo "  ✓ 归档完成"

# 步骤6: 导出 IPA
echo -e "${YELLOW}[5/6] 导出 IPA...${NC}"

# 创建 exportOptions.plist
cat > "$PROJECT_DIR/exportOptions.plist" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>development</string>
    <key>teamID</key>
    <string></string>
    <key>compileBitcode</key>
    <false/>
    <key>signingStyle</key>
    <string>manual</string>
</dict>
</plist>
PLIST

xcodebuild -exportArchive \
    -archivePath "$ARCHIVE_PATH" \
    -exportOptionsPlist "$PROJECT_DIR/exportOptions.plist" \
    -exportPath "$IPA_DIR" \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO \
    2>&1 | tail -5

# 步骤7: 完成
echo -e "${YELLOW}[6/6] 完成!${NC}"
echo ""

IPA_FILE=$(find "$IPA_DIR" -name "*.ipa" | head -n 1)
if [ -f "$IPA_FILE" ]; then
    IPA_SIZE=$(du -sh "$IPA_FILE" | cut -f1)
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  IPA 已生成!${NC}"
    echo -e "${GREEN}  文件: ${IPA_FILE}${NC}"
    echo -e "${GREEN}  大小: ${IPA_SIZE}${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo "安装方式:"
    echo "  1. Xcode 安装: 打开 Xcode → Window → Devices → 拖入 IPA"
    echo "  2. 蒲公英/fir.im: 上传到内测分发平台扫码安装"
    echo "  3. Apple Configurator 2: 连接 iPhone 后拖入安装"
    echo "  4. ideviceinstaller: brew install ideviceinstaller"
    echo "     ideviceinstaller -i $(basename "$IPA_FILE")"
else
    echo -e "${RED}未找到 IPA 文件，导出可能失败${NC}"
    echo "检查 $IPA_DIR 目录"
fi

rm -f "$PROJECT_DIR/exportOptions.plist"
