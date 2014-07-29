package com.em.presentation.tramix.informes.vo
{
	import com.em.presentation.common.util.EMRemoteService;
	import com.em.ui.EMBlocking;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	public class ServiceInforme
	{
		private var remote:EMRemoteService;
		public function ServiceInforme(blocking:EMBlocking=null)
		{
			remote = new EMRemoteService("InformeService", blocking);
		}
		
		public function findRadicacionesExp(filtros:Object, onResult:Function, onFault:Function):void{
			remote.setMetodoFiltro("findRadicacionesExp", filtros);
			remote.addListener(onResult, onFault);
		}

		public function findAccionRadicacion(filtros:Object, onResult:Function, onFault:Function):void{
			remote.setMetodoFiltro("findAccionRadicacion", filtros);
			remote.addListener(onResult, onFault);
		}
		
		public function getInformeRadicacionesExp(report:String, filtros:Object, onFault:Function):void{
			remote.setMetodoFiltro("getInformeRadicacionesExp", filtros);
			remote.getReport(report, null, onFault);
		}
		
		public function exportInformeRadicacionesExp(report:String, onFault:Function, ...filtros):void{
			remote.setMetodoFiltro("exportInformeRadicacionesExp", filtros, true);
			remote.getReport(report, null, onFault);
		}
		
	}
}