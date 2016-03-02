import QtQuick 2.4
import Ubuntu.Components 1.3
import "components"

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "rssreader.liu-xiao-guo"

    width: units.gu(60)
    height: units.gu(85)

    PageStack {
        id: pageStack
        anchors.fill: parent
        Component.onCompleted: {
            console.log('pagestack created')
            pageStack.push(listPage)
        }

        Page {
            id: listPage
            title: i18n.tr("POCO 摄影")
            visible: false

            head.actions: [
                Action {
                    iconName: "reload"
                    text: "Reload"
                    onTriggered: articleList.reload()
                }
            ]

            ArticleListView {
                id: articleList
                anchors.fill: parent
                clip: true

                onClicked: {
                    console.log('[flat] article clicked: '+instance.title)
                    articleContent.text = instance.content
                    pageStack.push(contentPage)
                }
            }
        }

        Page {
            id: contentPage
            title: i18n.tr("Content")
            visible: false

            ArticleContent {
                id: articleContent
                objectName: "articleContent"
                anchors.fill: parent
            }
        }
    }

    Action {
        id: reloadAction
        text: "Reload"
        iconName: "reload"
        onTriggered: articleList.reload()
    }
}

