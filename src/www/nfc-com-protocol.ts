//
//  Copyright 2018 IoTize SAS Inc.  Licensed under the MIT license. 
//
//  ble-com-protocol.ts
//  device-com-ble.cordova BLE Cordova Plugin
//

import { QueueComProtocol } from '@iotize/device-client.js/protocol/impl/queue-com-protocol';
import { ComProtocolConnectOptions, ComProtocolDisconnectOptions, ComProtocolSendOptions } from '@iotize/device-client.js/protocol/api/com-protocol.interface';
import { FormatHelper } from '@iotize/device-client.js/core/format/format-helper';
import { from, Observable } from 'rxjs';
import { CordovaInterface } from './cordova-interface';

declare var nfc: CordovaInterface;

export class NFCComProtocol extends QueueComProtocol {

    log(level: 'info' | 'error' | 'debug', ...args: any[]): void {
        console[level](level.toUpperCase() + " [NFCComProtocol] | " + args.map(entry => {
            if (typeof entry === 'object'){
                return JSON.stringify(entry);
            }
            else {
                return entry;
            }
        }).join(" "));
    }

   constructor() {
       super();
       this.options.connect.timeout = 2000;
       if (typeof nfc == undefined){
           console.warn("NFC plugin has not been setup properly. Global variable NFC does not exist");
       }
   }


    _connect(options?: ComProtocolConnectOptions): Observable<any> {
        this.log('info', '_connect', options);
        let connectPromise = nfc.connect("android.nfc.tech.NfcV", this.options.connect.timeout)
        return from(connectPromise);
    }


    _disconnect(options?: ComProtocolDisconnectOptions): Observable<any> {
        return from(nfc.close());
    }

    write(data: Uint8Array): Promise<any> {
        throw new Error("Method not implemented.");
    }

    read(): Promise<Uint8Array> {
        throw new Error("Method not implemented.");
    }

    send(data: Uint8Array, options ?: ComProtocolSendOptions): Observable<Uint8Array>{
        let promise = nfc
            .transceive(FormatHelper.toHexString(data))
            .then((response: string) => {
                if (typeof response != "string"){
                    throw new Error(`Internal error. Plugin should respond a hexadecimal string`);
                }
                this.log('debug', 'NFC plugin response: ', response)
                return FormatHelper.hexStringToBuffer(response)
            });
        return from(promise);
    }

 };

