use chat::{get_router, AppConfig};
use tokio::net::TcpListener;
use tracing::{info, level_filters::LevelFilter};
use tracing_subscriber::{fmt::Layer, layer::SubscriberExt, util::SubscriberInitExt, Layer as _};

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let layer = Layer::new().with_filter(LevelFilter::INFO);
    tracing_subscriber::registry().with(layer).init();

    let config = AppConfig::load()?;
    // let port = config.server.port;
    let addr = format!("0.0.0.0:{}", config.server.port);

    let app = get_router(config);
    let listener = TcpListener::bind(&addr).await?;
    info!("Listening on: {}", addr);

    axum::serve(listener, app.into_make_service()).await?;

    anyhow::Ok(())
}
