use std::collections::HashMap;

use wasmbus_rpc::actor::prelude::*;
use wasmcloud_interface_httpserver::{
    HttpRequest, HttpResponse, HttpServer, HttpServerReceiver, HttpServerSender,
};

mod ui;
use ui::Asset;

#[derive(Debug, Default, Actor, HealthResponder)]
#[services(Actor, HttpServer)]
struct ImageUiActor {}

#[async_trait]
impl HttpServer for ImageUiActor {
    async fn handle_request(&self, ctx: &Context, req: &HttpRequest) -> RpcResult<HttpResponse> {
        let path = req
            .path
            .trim()
            .trim_end_matches('/')
            .trim_start_matches('/');
        if req.method == "GET" {
            let path = if path.is_empty() { "index.html" } else { path };
            // Request for UI asset
            Ok(Asset::get(path)
                .map(|asset| {
                    let mut header = HashMap::new();
                    if let Some(content_type) = mime_guess::from_path(path).first() {
                        header.insert("Content-Type".to_string(), vec![content_type.to_string()]);
                    }
                    HttpResponse {
                        status_code: 200,
                        header,
                        body: Vec::from(asset.data),
                    }
                })
                .unwrap_or_else(|| HttpResponse::not_found()))
        } else {
            // forward to Inference API
            HttpServerSender::to_actor("inferenceapi")
                .handle_request(ctx, req)
                .await
        }
    }
}
