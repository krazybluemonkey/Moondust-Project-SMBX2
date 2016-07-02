/*
 * Platformer Game Engine by Wohlstand, a free platform for game making
 * Copyright (c) 2014-2016 Vitaly Novichkov <admin@wohlnet.ru>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <QtConcurrent>

#include <common_features/app_path.h>
#include <common_features/themes.h>
#include <common_features/spash_screen.h>
#include <main_window/dock/toolboxes.h>
#include <common_features/logger_sets.h>

#include <ui_mainwindow.h>
#include "mainwindow.h"

MainWindow::MainWindow(QMdiArea *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    continueLoad = false;

    this->setAttribute(Qt::WA_QuitOnClose, true);
    this->setAttribute(Qt::WA_DeleteOnClose, true);
    this->hide();
    setDefaults(); // Apply default common settings

    LogDebug(QString("Set UI..."));
    ui->setupUi(this);

    LogDebug(QString("Setting Lang..."));
    setDefLang();

    LogDebug(QString("Setting UI Defaults..."));
    setUiDefults(); //Apply default UI settings

#ifdef Q_OS_MACX
    ui->menuBar->setEnabled(false);
#endif
}


bool MainWindow::initEverything(QString configDir, QString themePack, bool ReAskConfigPack)
{
    askConfigAgain   = ReAskConfigPack;
    currentConfigDir = configDir;

    configs.setConfigPath( configDir );

    try
    {
        if(!configs.loadBasics())
            throw("Fail to load basic configurations");

        Themes::loadTheme( themePack );

        /*********************Splash Screen**********************/
        QPixmap splashimg(configs.splash_logo.isEmpty()?
                          Themes::Image(Themes::splash) :
                          configs.splash_logo);

        EditorSpashScreen splash(splashimg);
        splash.setCursor(Qt::ArrowCursor);
        splash.setDisabled(true);
        splash.setWindowFlags( splash.windowFlags() |  Qt::WindowStaysOnTopHint );

        for(int a=0; a<configs.animations.size();a++)
        {
            //QPoint pt(416,242);
            QPoint pt(int(configs.animations[a].x), int(configs.animations[a].y));
            //QPixmap img = QPixmap("coin.png");
            splash.addAnimation(pt,
                                configs.animations[a].img,
                                int(configs.animations[a].frames),
                                int(configs.animations[a].speed));
        }

        splash.connect(&configs, SIGNAL(progressMax(int)), &splash, SLOT(progressMax(int)));
        splash.connect(&configs, SIGNAL(progressTitle(QString)), &splash, SLOT(progressTitle(QString)));
        splash.connect(&configs, SIGNAL(progressValue(int)), &splash, SLOT(progressValue(int)));
        splash.connect(&configs, SIGNAL(progressPartsTotal(int)), &splash, SLOT(progressPartsMax(int)));
        splash.connect(&configs, SIGNAL(progressPartNumber(int)), &splash, SLOT(progressPartsVal(int)));

        /*********************Loading of config pack**********************/
        // Do the loading in a thread
        QFuture<bool> isOk = QtConcurrent::run(&this->configs, &dataconfigs::loadconfigs);
        /*********************Loading of config pack**********************/

        /*********************Splash Screen**********************/
        // And meanwhile load the settings in the main thread
        loadSettings();

        #ifndef Q_OS_ANDROID
        splash.show();
        #else
        splash.showFullScreen();
        #endif
        splash.startAnimations();

        // Now wait until the config load in finished.
        while(!isOk.isFinished()) { qApp->processEvents(); QThread::msleep(64); }

        /*********************Splash Screen end**********************/
        splash.finish(this);
        /*********************Splash Screen end**********************/
        if(!isOk.result())
        {
            throw("Error loading configuration package");
        }

        if(configs.check())
        {
            QMessageBox::warning(this, tr("Configuration error"),
                tr("Configuration package is loaded with errors."), QMessageBox::Ok);
            on_actionCurConfig_triggered();
        }

        continueLoad = true;

        splash.progressTitle(tr("Loading theme..."));

        applyTheme( Themes::currentTheme().isEmpty() ? ConfStatus::defaultTheme : Themes::currentTheme() );

    #ifdef Q_OS_MACX
        ui->menuBar->setEnabled(true);
    #endif

    #ifdef Q_OS_WIN
        if(ConfStatus::SmbxTest_By_Default)
        {
            ui->action_doTest->setShortcut(QStringLiteral(""));
            ui->action_doTest->setShortcutContext(Qt::WindowShortcut);

            ui->actionRunTestSMBX->setShortcut(QStringLiteral("F5"));
            ui->actionRunTestSMBX->setShortcutContext(Qt::WindowShortcut);
        }
    #endif

        splash.progressTitle(tr("Initializing dock widgets..."));

        //Apply objects into tools
        dock_LvlSectionProps->initDefaults();
        //dock_LvlItemBox->setLvlItemBoxes();
        //dock_WldItemBox->setWldItemBoxes();
        dock_LvlEvents->reloadSoundsList();
        dock_WldItemProps->WldLvlExitTypeListReset();
        dock_TilesetBox->setTileSetBox(true);

        splash.progressTitle(tr("Finishing loading..."));
    }
    catch(...)
    {
        LogWriter::logLevel = PGE_LogLevel::Debug; //Force debug log
        QMessageBox::critical(this, tr("Configuration error"),
                              tr("Configuration can't be loaded.\nSee in %1 for more information.")
                              .arg(LogWriter::DebugLogFile),
                              QMessageBox::Ok);
        LogFatal("<Error, application closed>");
        continueLoad = false;
        return false;
    }
    return true;
}

MainWindow::~MainWindow()
{
#ifdef Q_OS_WIN
    if(pge_thumbbar)
        delete pge_thumbbar;

    DWORD lpExitCode=0;
    if(GetExitCodeProcess(m_luna_pi.hProcess, &lpExitCode))
    {
        if(lpExitCode==STILL_ACTIVE)
        {
            WaitForSingleObject(m_luna_pi.hProcess, 100);
            TerminateProcess(m_luna_pi.hProcess, lpExitCode);
            CloseHandle(m_luna_pi.hProcess);
        }
    }

    if(m_luna_ipc_pipe)
    {
        CloseHandle(m_luna_ipc_pipe);
        m_luna_ipc_pipe = 0;
    }
#endif
    delete ui;
}


//////////////////SLOTS///////////////////////////

//Exit from application
void MainWindow::on_Exit_triggered()
{
    if(!MainWindow::close())
        return;
}

void MainWindow::formatErrorMsgBox(QString filePath, QString errorMessage, long lineNum, QString lineContents)
{
    QMessageBox::warning(this, QObject::tr("Bad File"),
                PGESTRING( QObject::tr("Bad file format\nFile: %1").arg(filePath+"\n")  //Print Bad data string
                        +( errorMessage.isEmpty()?"":errorMessage+"\n" ) //Print special error message
                        +( lineNum < 0 ? "":QObject::tr("Line Number: %1").arg(lineNum)+"\n" )         //Print Line With error
                        +( lineContents.isEmpty()?"":QObject::tr("Line Data: %1").arg(lineContents)) ),
                         QMessageBox::Ok);
}

//Toolbar context menu
void MainWindow::on_MainWindow_customContextMenuRequested(const QPoint &pos)
{
    LogDebug(QString("Main Menu's context menu called! %1 %2").arg(pos.x()).arg(pos.y()));

    QMenu *cu = new QMenu(this);
    QAction *test= cu->addAction("Nothing");
    test->setEnabled(false);
    QAction *test2= cu->addAction("Nothing");
    test2->setEnabled(false);
    QAction *test3= cu->addAction("Nothing");
    test3->setEnabled(false);

    cu->exec(pos);
}


void MainWindow::showStatusMsg(QString msg, int time)
{
    statusBar()->showMessage(msg, time);
}

void MainWindow::on_actionRefresh_menu_and_toolboxes_triggered()
{
    updateMenus(ui->centralWidget->activeSubWindow(), true);
}

