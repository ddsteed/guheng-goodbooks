#!/usr/bin/env bash

# This script is to convert 顾衡好书榜 to different ebook formats.

function substitute () {
    file=$1
    
    echo " - replace special characters ... "

    sed -e '8,$s/\([^\#]|[^\.]|[^a-z]|[^\-]|[^\>]\) /\1/g' \
        -e '8,$s/,/，/g' \
        -e '8,$s/．/./g' \
        -e '8,$s/⋯⋯/....../g' \
        -e '8,$s/⋯/....../g' \
        -e '8,$s/•/./g' \
        -e '8,$s/;/；/g' \
        -e '8,$s/?/？/g' \
        -e '8,$s/!/！/g' \
        -e '8,$s/——/---/g' \
        $file.md > $file_tmp.md

    # That *_tmp.md is empty means replacing special characters is NOT right.
    if [ -s $file_tmp.md ]; then
        mv $file_tmp.md  $file.md
    else
        echo "NOT succeed in replacing $file.md"
        exit
    fi
}

function m2e () {
    echo " - transform to epub ..."

    pandoc -s --toc --toc-depth=2 \
           --epub-cover-image=./fig/cover.png \
           $file.md -f markdown -o $file.epub
}

function m2p () {
    echo " - transform to pdf ..."

    pandoc --pdf-engine=xelatex \
           --toc -N \
           -V colorlinks -V urlcolor=NavyBlue \
           --highlight-style zenburn \
           $file.md -o $file.pdf
}

# ------------------------------------------------------------
# main function

if [[ $1 == "" ]]; then
    titles=(顾衡好书榜 发刊词 国家 媒介 人物 政治 仲春说春 知识分子 美国 日本 俄罗斯 拉美 科学 一战 民族 社会)
else
    titles=($1)
fi


for title in ${titles[@]}; do
    content=()
    case $title in
        顾衡好书榜)
            content=(${content[@]} 发刊词)
            content=(${content[@]} 国家的视角 秦汉帝国 人口浪潮)
            content=(${content[@]} 技术垄断 文字的力量)
            content=(${content[@]} 俾斯麦 伯林传 托马斯克伦威尔)
            content=(${content[@]} 誓言 至高权力 秩序 不平等社会 全球不平等逸史 反对选举 风暴眼 火与烬)
            content=(${content[@]} 婚姻史 我们为何结婚 邻人之妻 告别伊甸园)
            content=(${content[@]} 专家之死 知识分子)
            content=(${content[@]} 谁是美国人 美国秩序的根基 独自打保龄球 美国的难题 谁丢了美国)
            content=(${content[@]} 日本生存的艺术 水俣病 日俄战争 第二次世界大战在亚洲及太平洋的起源)
            content=(${content[@]} 走向火焰)
            content=(${content[@]} 掉队的拉美)
            content=(${content[@]} 奇妙的生命)
            content=(${content[@]} 一战爆发的原因 一战的主要过程 一战对欧洲的影响 一战对亚洲的影响 雅尔塔)
            content=(${content[@]} 想象的共同体 发明民族主义 法国资产阶级)
            content=(${content[@]} 病床边的陌生人 想太多的人类学家 自行车的回归 剧变 陌生人溺水 特别放送 赢家的诅咒 玫瑰的名字)
            ;;
        发刊词)
            content=(${content[@]} 发刊词)
            ;;
        国家)
            content=(${content[@]} 国家的视角 秦汉帝国 人口浪潮)
            ;;
        媒介)
            content=(${content[@]} 技术垄断 文字的力量)
            ;;
        人物)
            content=(${content[@]} 俾斯麦 伯林传 托马斯克伦威尔)
            ;;
        政治)
            content=(${content[@]} 誓言 至高权力 秩序 不平等社会 全球不平等逸史 反对选举 风暴眼 火与烬)
            ;;
        仲春说春)
            content=(${content[@]} 婚姻史 我们为何结婚 邻人之妻 告别伊甸园)
            ;;
        知识分子)
            content=(${content[@]} 专家之死 知识分子)
            ;;
        美国)
            content=(${content[@]} 谁是美国人 美国秩序的根基 独自打保龄球 美国的难题 谁丢了美国)
            ;;
        日本)
            content=(${content[@]} 日本生存的艺术 水俣病 日俄战争 第二次世界大战在亚洲及太平洋的起源)
            ;;
        俄罗斯)
            content=(${content[@]} 走向火焰)
            ;;
        拉美)
            content=(${content[@]} 掉队的拉美)
            ;;
        科学)
            content=(${content[@]} 奇妙的生命)
            ;;
        一战)
            content=(${content[@]} 一战爆发的原因 一战的主要过程 一战对欧洲的影响 一战对亚洲的影响 雅尔塔)
            ;;
        民族)
            content=(${content[@]} 想象的共同体 发明民族主义 法国资产阶级)
            ;;
        社会)
            content=(${content[@]} 病床边的陌生人 想太多的人类学家 自行车的回归 剧变 陌生人溺水 特别放送 赢家的诅咒 玫瑰的名字)
            ;;
    esac

    echo
    echo "*** To convert $title to different ebook formats *** "
    echo

    cp ./title/$title.md .

    for chapter in ${content[@]}; do
        cat md/$chapter.md >> $title.md
    done

    substitute $title
    m2e $title && mv $title.epub epub/.
    m2p $title && mv $title.pdf  pdf/.

    rm $title.md

done
