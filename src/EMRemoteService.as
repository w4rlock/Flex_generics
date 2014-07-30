package com.em.presentation.common.util
{
	import com.em.ui.EMBlocking;
	import com.em.ui.EMMessage;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	import mx.utils.StringUtil;

	public class EMRemoteService
	{
		
		private var _token:AsyncToken=null;
		private var _remote:RemoteObject=null;
		private var _metodo:String;
		private var _param:Object;
		private var _blocking:EMBlocking;
		private var _isVarArg:Boolean;
		
		public function EMRemoteService(service:String, blocking:EMBlocking=null, useBusyCurse:Boolean=true)
		{
			_remote = new RemoteObject(service);
			_blocking = blocking;
			_remote.showBusyCursor = useBusyCurse;
		}
		
		public function useBlocking(blocking:EMBlocking):void{ _blocking = blocking; }
		public function setMetodo(metodo:String):void{ this._metodo = metodo; }
		public function setFiltro(filtro:*):void{ this._param = filtro;	}
		public function setMetodoFiltro(metodo:String, filtro:Object, isVarArg:Boolean=false):void{
			this._param = filtro;
			this._metodo = metodo;
			this._isVarArg = isVarArg;
		}
		
		private function defaultCall():void{
			if (_param == null){
				_token = _remote.getOperation(_metodo).send();
			}
			else if (_isVarArg){ //metodos de java con mas de 1 argumento
				_token = _remote.getOperation(_metodo).send.apply(null,_param);
			}
			else{
				_token = _remote.getOperation(_metodo).send(_param);
			}
			if (_blocking != null){
				_blocking.block();
			}
		}
		
		public function addListener(onResult:Function, onFaultCb:Function):void{
			defaultCall();
			_token.addResponder(new AsyncResponder(
				function(ev:ResultEvent, token:Object):void{
					if (_blocking != null){
						_blocking.unblock();
					}
					if (onResult != null){
						if (ev.result is Array){
							onResult(new ArrayCollection(ev.result as Array));
						}
						else{
							onResult(ev.result);
						}
					}
				},
				function onFault(ev:FaultEvent, token:Object):void{
					if (_blocking != null){
						_blocking.unblock();
					}
					if (onFault != null){
						onFaultCb(ev.fault.faultString);
					}
				}
			));	
		}
		
		public function getReport(reportName:String="Reporte.pdf", onResult:Function=null, onError:Function=null):void{
			this.addListener(
				function(res:String):void{
					if ((res != null) && (StringUtil.trim(res).length > 0)){
						var vars:String = TramixRemoteFile.PARAM_COMMAND + "=" + TramixRemoteFile.COM_DOWNLOAD +
						"&" + TramixRemoteFile.PARAM_ICOMMAND + "=" + TramixRemoteFile.ICOM_GET_REP +
						"&" + TramixRemoteFile.PARAM_FILE + "=" + res.substr(res.lastIndexOf("/") + 1) +
						"&" + TramixRemoteFile.PARAM_OP + "=" + reportName;
						EMUtilTramix.navigateTo(TramixRemoteFile.DOWNLOAD_URL, vars);
					}
					if (onResult != null){ onResult(res); }
				}, 
				onError
			);
			
		}
	}
}