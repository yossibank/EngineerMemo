TEMPLATE_DIR=~/Library/Developer/Xcode/Templates/File\ Templates/MVVM

if [ ! -d "${TEMPLATE_DIR}" ]; then
    mkdir -p "${TEMPLATE_DIR}"
fi

cp -r EngineerMemo.xctemplate/ "${TEMPLATE_DIR}"