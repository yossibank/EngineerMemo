TEMPLATE_DIR=~/Library/Developer/Xcode/Templates/File\ Templates/Architecture

if [ ! -d "${TEMPLATE_DIR}" ]; then
    mkdir -p "${TEMPLATE_DIR}"
fi

cp -r MVVMArchitectureTemplate.xctemplate/ "${TEMPLATE_DIR}"