import gleam/uri.{type Uri}
import lustre
import lustre/attribute
import lustre/effect
import lustre/element
import lustre/element/html
import modem

// MAIN -----------------------------------------------------------------------

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

fn init(_flags: Nil) -> #(Route, effect.Effect(Msg)) {
  let route = case modem.initial_uri() {
    Ok(uri) -> parse_route(uri.path)
    Error(_) -> Home
  }

  #(route, modem.init(on_url_change))
}

// MODEL ----------------------------------------------------------------------

pub type Route {
  Home
  About
  Projects
  Contact
}

pub type Msg {
  OnRouteChange(Route)
}

// ROUTING --------------------------------------------------------------------
fn on_url_change(uri: Uri) -> Msg {
  OnRouteChange(parse_route(uri.path))
}

fn parse_route(path: String) -> Route {
  case uri.path_segments(path) {
    ["About"] -> About
    ["Projects"] -> Projects
    ["Contact"] -> Contact
    _ -> Home
  }
}

// UPDATE ---------------------------------------------------------------------
fn update(_, msg: Msg) -> #(Route, effect.Effect(Msg)) {
  case msg {
    OnRouteChange(route) -> #(route, effect.none())
  }
}

// VIEW HELPERS ---------------------------------------------------------------
fn nav_link(label: String, path: String) -> element.Element(Msg) {
  html.a([attribute.href(path)], [element.text(label)])
}

fn view_route(route: Route) -> element.Element(Msg) {
  case route {
    Home ->
      html.div([], [
        html.h1([], [element.text("Welcome to Studio Greg")]),
        html.p([], [
          element.text(
            "A polished portfolio scaffold for projects, writing, and experiments.",
          ),
        ]),
      ])
    About ->
      html.div([], [
        html.h1([], [element.text("About")]),
        html.p([], [
          element.text(
            "Studio Greg.",
          ),
        ]),
      ])
    Projects ->
      html.div([], [
        html.h1([], [element.text("Projects")]),
        html.ul([], [
          html.li([], [element.text("Project 1 — Example app")]),
          html.li([], [element.text("Project 2 — Portfolio showcase")]),
        ]),
      ])
    Contact ->
      html.div([], [
        html.h1([], [element.text("Contact")]),
        html.p([], [element.text("Let’s connect — hello@greg.studio")]),
      ])
  }
}

// VIEW -----------------------------------------------------------------------
fn view(route: Route) -> element.Element(Msg) {
  html.div([], [
    html.nav([], [
      nav_link("Home", "/"),
      nav_link("About", "/About"),
      nav_link("Projects", "/Projects"),
      nav_link("Contact", "/Contact"),
    ]),
    html.section([], [view_route(route)]),
  ])
}
