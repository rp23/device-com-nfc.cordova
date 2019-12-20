package com.chariotsolutions.nfc.plugin;

class NfcPluginError extends Exception {

    String code;

    public String getCode() {
        return code;
    }

    public NfcPluginError(String code, String message, Throwable cause) {
        super(message, cause);
        this.code = code;
    }
}
