#-------------------------------------------------
#
# Project created by QtCreator 2014-03-18T16:09:15
#
#-------------------------------------------------

QT       += core gui widgets multimedia

CONFIG += static

TARGET = pge_editor
TEMPLATE = app

TRANSLATIONS += languages/pge_editor_en.ts \
    languages/pge_editor_ru.ts \
    languages/pge_editor_de.ts \
    languages/pge_editor_es.ts

SOURCES += main.cpp\
        mainwindow.cpp \
    aboutdialog.cpp \
    file_formats/file_formats.cpp \
    file_formats/file_lvl.cpp \
    file_formats/file_npc_txt.cpp \
    file_formats/file_wld.cpp \
    file_formats/smbx64.cpp \
    main_window/recentfiles.cpp \
    main_window/events.cpp \
    main_window/main_settings.cpp \
    main_window/clipboard.cpp \
    main_window/sub_windows.cpp \
    main_window/data_configs.cpp \
    main_window/edit_level.cpp \
    main_window/edit_world.cpp \
    main_window/music_player.cpp \
    main_window/edit_common.cpp \
    main_window/files_io.cpp \
    main_window/menubar.cpp \
    main_window/edit_control.cpp \
    main_window/appsettings.cpp \
    main_window/edit_level_layers.cpp \
    level_scene/lvlscene.cpp \
    level_scene/item_bgo.cpp \
    level_scene/item_block.cpp \
    level_scene/HistoryManager.cpp \
    level_scene/lvl_clipboard.cpp \
    level_scene/item_npc.cpp \
    level_scene/place_new_item.cpp \
    level_scene/lvl_control.cpp \
    level_scene/lvl_items.cpp \
    level_scene/lvl_usergfx.cpp \
    level_scene/itemmsgbox.cpp \
    level_scene/lvl_collisions.cpp \
    level_scene/newlayerbox.cpp \
    data_configs/configs_main.cpp \
    data_configs/conf_lvl_bgo.cpp \
    data_configs/conf_lvl_bkgrd.cpp \
    data_configs/conf_lvl_block.cpp \
    data_configs/conf_lvl_npc.cpp \
    data_configs/conf_music.cpp \
    common_features/timecounter.cpp \
    common_features/logger.cpp \
    common_features/musicfilelist.cpp \
    edit_npc/npcedit.cpp \
    npc_dialog/npcdialog.cpp \
    edit_level/leveledit.cpp \
    edit_level/levelprops.cpp \
    edit_level/saveimage.cpp \
    edit_level/lvl_files_io.cpp \
    edit_level/lvl_draw.cpp \
    edit_level/lvl_edit_control.cpp \
    edit_npc/npctxt_files_io.cpp \
    edit_npc/npc_data_sets.cpp \
    edit_npc/npctxt_controls.cpp

HEADERS  += mainwindow.h \
    aboutdialog.h \
    file_formats/file_formats.h \
    level_scene/item_bgo.h \
    level_scene/item_block.h \
    level_scene/lvlscene.h \
    level_scene/item_npc.h \
    data_configs/data_configs.h \
    common_features/timecounter.h \
    common_features/logger.h \
    common_features/logger_sets.h \
    common_features/musicfilelist.h \
    npc_dialog/npcdialog.h \
    level_scene/itemmsgbox.h \
    main_window/appsettings.h \
    level_scene/newlayerbox.h \
    file_formats/lvl_filedata.h \
    file_formats/npc_filedata.h \
    file_formats/wld_filedata.h \
    edit_level/leveledit.h \
    edit_level/levelprops.h \
    edit_level/saveimage.h \
    edit_npc/npcedit.h

FORMS    += \
    aboutdialog.ui \
    mainwindow.ui \
    npc_dialog/npcdialog.ui \
    level_scene/itemmsgbox.ui \
    main_window/appsettings.ui \
    level_scene/tonewlayerbox.ui \
    common_features/musicfilelist.ui \
    edit_level/leveledit.ui \
    edit_level/levelprops.ui \
    edit_level/saveimage.ui \
    edit_npc/npcedit.ui

RC_FILE = platgenw.rc

macx {
    ICON = images/mac/mushroom.icns
}

OTHER_FILES += \
    images/saveas.png \
    images/save.png \
    images/open.png \
    images/new.png \
    images/world.png \
    images/saveas.png \
    images/save.png \
    images/rubber.png \
    images/open.png \
    images/new.png \
    images/mushroom.png \
    images/level.png \
    images/arrow.png \
    images/21.png \
    images/20.png \
    images/19.png \
    images/18.png \
    images/17.png \
    images/16.png \
    images/15.png \
    images/14.png \
    images/13.png \
    images/12.png \
    images/11.png \
    images/10.png \
    images/09.png \
    images/08.png \
    images/07.png \
    images/06.png \
    images/05.png \
    images/04.png \
    images/03.png \
    images/02.png \
    images/01.png \
    platgenw.rc \
    images/unknown_npc.gif \
    images/unknown_block.gif \
    images/unknown_bgo.gif \
    images/world16.png \
    images/section16.png \
    images/mushroom16.png \
    images/level16.png \
    splash.png \
    mushroom.ico \
    images/coin.png \
    images/cur_rubber.png \
    images/grid.png \
    images/hand.png \
    images/lock_bgo_cl.png \
    images/lock_bgo_op.png \
    images/lock_block_cl.png \
    images/lock_block_op.png \
    images/lock_door_cl.png \
    images/lock_door_op.png \
    images/lock_npc_cl.png \
    images/lock_npc_op.png \
    images/lock_water_cl.png \
    images/lock_water_op.png \
    images/player1_point.png \
    images/player1_start.png \
    images/player2_point.png \
    images/player2_start.png \
    images/playmusic.png \
    images/reload_data.png \
    images/reset_pos.png \
    images/section.png \
    images/splash.png \
    images/warp_entrance.png \
    images/warp_exit.png

RESOURCES += \
    editor.qrc
