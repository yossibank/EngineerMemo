TEMPLATE_DIR=~/Library/Developer/Xcode/Templates/File\ Templates/Architecture

rm -r "${TEMPLATE_DIR}"
mkdir -p "${TEMPLATE_DIR}"
cp -r EngineerResume.xctemplate/ "${TEMPLATE_DIR}"