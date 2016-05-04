import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.0

Item {
    id: root
    signal clicked(var instance)
    anchors.fill: parent

    function reload() {
        console.log('reloading')
        model.clear();
        picoRssModel.reload()
    }

    ListModel {
        id: model
    }

    XmlListModel {
        id: picoRssModel
        source: "http://www.8kmm.com/rss/rss.aspx"
        query: "/rss/channel/item"

        onStatusChanged: {
            if (status === XmlListModel.Ready) {
                for (var i = 0; i < count; i++) {
                    // Let's extract the image
                    var m,
                        urls = [],
                        str = get(i).content,
                        rex = /<img[^>]+src\s*=\s*['"]([^'"]+)['"][^>]*>/g;

                    while ( m = rex.exec( str ) ) {
                        urls.push( m[1] );
                    }

                    var image = urls[0];

                    var title = get(i).title.toLowerCase();
                    var published = get(i).published.toLowerCase();
                    var content = get(i).content.toLowerCase();
                    var word = input.text.toLowerCase();

                    if ( (title !== undefined && title.indexOf( word) > -1 )  ||
                         (published !== undefined && published.indexOf( word ) > -1) ||
                         (content !== undefined && content.indexOf( word ) > -1) ) {

                            model.append({"title": get(i).title,
                                         "published": get(i).published,
                                         "content": get(i).content,
                                         "image": image
                                     })
                    }
                }
            }
        }

        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "published"; query: "pubDate/string()" }
        XmlRole { name: "content"; query: "description/string()" }
    }

    UbuntuListView {
        id: listView
        width: parent.width
        height: parent.height - inputcontainer.height
        clip: true
        visible: true

        model: model

        delegate: ListDelegate {}

        // Define a highlight with customized movement between items.
        Component {
            id: highlightBar
            Rectangle {
                width: 200; height: 50
                color: "#FFFF88"
                y: listView.currentItem.y;
                Behavior on y { SpringAnimation { spring: 2; damping: 0.1 } }
            }
        }

        highlightFollowsCurrentItem: true

        focus: true
        // highlight: highlightBar

        Scrollbar {
            flickableItem: listView
        }

        PullToRefresh {
            onRefresh: {
                reload()
            }
        }
    }

    Row {
        id:inputcontainer
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        height: units.gu(5)
        spacing:12

        Icon {
            width: height
            height: parent.height
            name: "search"
            anchors.verticalCenter:parent.verticalCenter;
        }

        TextField {
            id:input
            placeholderText: "请输入关键词搜索:"
            width:units.gu(25)
            text:""

            onTextChanged: {
                console.log("text is changed");
                reload();
            }
        }
    }
}
