import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("模拟信号交通灯")

    // 模拟交通信号灯
    property int totalTime: 0
    Component.onCompleted: {
        totalTime = 10;
    }

    Rectangle {
        width: 130
        height: 440
        color: "black"
        anchors.top: parent.top;
        anchors.left: parent.left;
        anchors.topMargin: 50
        anchors.centerIn: parent

        // 红灯倒计时，绿灯倒计时，黄灯倒计时
        Text {
            id: countDown
            text: parent.state === "stop" ? `红灯倒计时：${totalTime}`:
                   (parent.state === "go" ? `绿灯倒计时：${totalTime}` : `黄灯倒计时：${totalTime}` )
            color: "#fff"
            // font.pixelSize: 30
            anchors.horizontalCenter: parent.horizontalCenter
            y: 20
            onTextChanged: {
                if(time.running) {
                    // ... action
                }
            }
        }

        Rectangle {
            id: redLight
            x: 5
            y: 50
            width: 120
            height: 120
            radius: 60
            smooth: true
        }
        Rectangle {
            id: yellowLight
            x: redLight.x
            y: redLight.y+redLight.height+10
            width: redLight.width
            height: redLight.height
            radius: redLight.radius
            smooth: true
        }
        Rectangle {
            id: greenLight
            x: redLight.x
            y: yellowLight.y+yellowLight.height+10
            width: redLight.width
            height: redLight.height
            radius: redLight.radius
            smooth: true
        }

        states: [
            State{
                name: "stop"
                PropertyChanges {
                    target: redLight; color: "red"
                }
                PropertyChanges {
                    target: yellowLight; color: "lightslategrey"
                }
                PropertyChanges {
                    target: greenLight; color: "lightslategrey"
                }
                PropertyChanges {
                    target: time; interval: 10000
                }
            },
            State{
                name: "go"
                PropertyChanges {
                    target: redLight; color: "lightslategrey"
                }
                PropertyChanges {
                    target: yellowLight; color: "lightslategrey"
                }
                PropertyChanges {
                    target: greenLight; color: "green"
                }
                PropertyChanges {
                    target: time; interval: 8000
                }
            },
            State{
                name: "wait"
                PropertyChanges {
                    target: redLight; color: "lightslategrey"
                }
                PropertyChanges {
                    target: yellowLight; color: "yellow"
                }
                PropertyChanges {
                    target: greenLight; color: "lightslategrey"
                }
                PropertyChanges {
                    target: time; interval: 3000
                }
            }
        ]

        state: "stop"

        transitions: [
            Transition {
                from: "stop"
                to: "go"
                ParallelAnimation{
                    PropertyAnimation{
                        target: redLight
                        properties: "color"
                        duration: 1000
                    }
                    PropertyAnimation{
                        target: greenLight
                        properties: "color"
                        duration: 1000
                    }
                }
            },
            Transition {
                from: "go"
                to: "wait"
                ParallelAnimation{
                    PropertyAnimation{
                        target: greenLight
                        properties: "color"
                        duration: 1000
                    }
                    PropertyAnimation{
                        target: yellowLight
                        properties: "color"
                        duration: 1000
                    }
                }
            },
            Transition {
                from: "wait"
                to: "stop"
                ParallelAnimation{
                    PropertyAnimation{
                        target: redLight
                        properties: "color"
                        duration: 1000
                    }
                    PropertyAnimation{
                        target: yellowLight
                        properties: "color"
                        duration: 1000
                    }
                }
            }
        ]
        // 状态倒计时
        Timer {
            id: time
            // interval: 10000
            running: true;
            repeat: true;
            onTriggered: {
                // 根据当前状态切换到下一个状态，并重置 totalTime 和 interval
                if(parent.state === "stop") {
                    parent.state = "go"
                    totalTime = 8 // 绿灯时间
                    time.interval = 8000 // 绿灯间隔
                } else if(parent.state === "go") {
                    parent.state = "wait"
                    totalTime = 3 // 黄灯时间
                    time.interval = 3000;
                } else if(parent.state === "wait") {
                    parent.state = "stop"
                    totalTime = 10 // 红灯时间
                    time.interval = 10000 // 红灯间隔
                }
            }
        }
        // 秒倒计时
        Timer {
            id: countDownTime
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                if(totalTime > 0) {
                    totalTime -= 1;
                }
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: Qt.quit();
        }
    }
}
