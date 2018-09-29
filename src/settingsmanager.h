﻿#pragma once

#include <QSettings>

class SettingsManager
{
public:
    static SettingsManager *getInstance();

public:
    bool regAutostart();
    void unregAutostart();

    QStringList defaultDecoders() const;
    QStringList supportedMimeTypes() const;

    QString getUrl() const;
    bool getMute() const;
    unsigned int getVolume() const;
    bool getAutostart() const;
    bool getHwdec() const;
    QStringList getDecoders() const;
    bool getLocalize() const;
    bool getFitDesktop() const;
    bool getSubtitle() const;
    QString getCharset() const;
    bool getSubtitleAutoLoad() const;
    bool getAudioAutoLoad() const;
    int getCurrentVideoStream() const;
    int getCurrentAudioStream() const;
    const QVariant &getCurrentSubtitleStream() const;

    void setUrl(const QString &url);
    void setMute(bool mute);
    void setVolume(unsigned int volume);
    void setAutostart(bool enable);
    void setHwdec(bool enable);
    void setDecoders(const QStringList &decoders);
    void setLocalize(bool enable);
    void setFitDesktop(bool fit);
    void setSubtitle(bool show);
    void setCharset(const QString &charset);
    void setSubtitleAutoLoad(bool autoload);
    void setAudioAutoLoad(bool autoload);
    void setCurrentVideoStream(int stream);
    void setCurrentAudioStream(int stream);
    void setCurrentSubtitleStream(const QVariant &stream);

private:
    SettingsManager();
    ~SettingsManager();

private:
    QSettings *settings;
    int currentVideoStream = 0, currentAudioStream = 0;
    QVariant currentSubtitleStream;
};