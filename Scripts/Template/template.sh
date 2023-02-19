TEMPLATE_DIR=~/Library/Developer/Xcode/Templates/File\ Templates

rm -rf "${TEMPLATE_DIR}"

if [ ! -d "${TEMPLATE_DIR}" ]; then
    mkdir -p "${TEMPLATE_DIR}"
fi

cp -r EngineerMemo.xctemplate/My\ MVVM\ Architecture "${TEMPLATE_DIR}"
cp -r EngineerMemo.xctemplate/My\ MVVM\ ArchitectureTest "${TEMPLATE_DIR}"
cp -r EngineerMemo.xctemplate/My\ SnapshotTest "${TEMPLATE_DIR}"
cp -r EngineerMemo.xctemplate/My\ UIHelper "${TEMPLATE_DIR}"