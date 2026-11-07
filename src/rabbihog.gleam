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

fn site_header() -> element.Element(Msg) {
  html.header([attribute.class("site-header")], [
    html.nav([attribute.class("nav-shell"), attribute.aria_label("Main navigation")], [
      html.a([attribute.class("brand"), attribute.href("/")], [
        html.span([attribute.class("brand-mark"), attribute.aria_hidden(True)], [
          element.text("g"),
        ]),
        html.span([], [element.text("Studio Greg")]),
      ]),
      html.div([attribute.class("nav-links")], [
        nav_link("About", "/About"),
        nav_link("Projects", "/Projects"),
      ]),
      html.a([attribute.class("button button-small"), attribute.href("/Contact")], [
        element.text("Get in touch"),
        html.span([attribute.aria_hidden(True)], [element.text("↗")]),
      ]),
    ]),
  ])
}

fn site_footer() -> element.Element(Msg) {
  html.footer([attribute.class("site-footer")], [
    html.div([attribute.class("footer-shell")], [
      html.a([attribute.class("brand brand-footer"), attribute.href("/")], [
        html.span([attribute.class("brand-mark"), attribute.aria_hidden(True)], [
          element.text("g"),
        ]),
        html.span([], [element.text("Studio Greg")]),
      ]),
      html.p([], [element.text("Made with curiosity.")]),
      html.a([attribute.href("/Contact")], [
        element.text("hello@greg.studio"),
        html.span([attribute.aria_hidden(True)], [element.text(" ↗")]),
      ]),
    ]),
  ])
}

fn project_card(
  number: String,
  title: String,
  description: String,
  visual_class: String,
) -> element.Element(Msg) {
  html.a([attribute.class("project-card"), attribute.href("/Projects")], [
    html.div([attribute.class("project-visual " <> visual_class), attribute.aria_hidden(True)], [
      html.span([attribute.class("visual-index")], [element.text(number)]),
      html.div([attribute.class("visual-shape")], []),
      html.span([attribute.class("visual-arrow")], [element.text("↗")]),
    ]),
    html.div([attribute.class("project-copy")], [
      html.div([attribute.class("project-title-row")], [
        html.h3([], [element.text(title)]),
        html.span([attribute.class("project-arrow"), attribute.aria_hidden(True)], [
          element.text("↗"),
        ]),
      ]),
      html.p([], [element.text(description)]),
    ]),
  ])
}

fn view_route(route: Route) -> element.Element(Msg) {
  case route {
    Home ->
      html.main([], [
        html.section([attribute.class("hero")], [
          html.div([attribute.class("hero-inner")], [
            html.div([attribute.class("hero-copy")], [
              html.p([attribute.class("eyebrow")], [
                html.span([attribute.class("eyebrow-dot"), attribute.aria_hidden(True)], []),
                element.text("WELCOME TO STUDIO GREG"),
              ]),
              html.h1([], [
                element.text("Let’s build something "),
                html.span([attribute.class("gradient-text")], [
                  element.text("great"),
                ]),
                element.text(" together."),
              ]),
              html.p([attribute.class("hero-description")], [
                element.text(
                  "Studio Greg is a digital product development studio. 
                  We're ready to launch your next custom application, platform, or feature."
                ),
              ]),
              html.div([attribute.class("hero-actions")], [
                html.a([attribute.class("button"), attribute.href("/Contact")], [
                  element.text("Start a conversation"),
                  html.span([attribute.aria_hidden(True)], [element.text("↗")]),
                ]),
                html.a([attribute.class("text-link"), attribute.href("/Projects")], [
                  element.text("Explore the work"),
                  html.span([attribute.aria_hidden(True)], [element.text("→")]),
                ]),
              ]),
            ]),
            html.div([attribute.class("hero-art"), attribute.aria_hidden(True)], [
              html.div([attribute.class("art-orbit orbit-one")], []),
              html.div([attribute.class("art-orbit orbit-two")], []),
              html.div([attribute.class("art-core")], [
                html.span([], [element.text("SG")]),
              ]),
              html.div([attribute.class("art-label art-label-top")], [
                element.text("IDEAS"),
              ]),
              html.div([attribute.class("art-label art-label-bottom")], [
                element.text("IN MOTION"),
              ]),
            ]),
          ]),
          html.div([attribute.class("hero-bottom")], [
            html.span([], [element.text("INDEPENDENT BY DESIGN")]),
            html.span([attribute.class("hero-bottom-line"), attribute.aria_hidden(True)], []),
            html.span([], [element.text("BUILT WITH CURIOSITY")]),
          ]),
        ]),
        html.section([attribute.class("intro-section")], [
          html.div([attribute.class("section-shell intro-grid")], [
            html.div([], [
              html.p([attribute.class("eyebrow eyebrow-dark")], [
                element.text("A LITTLE ABOUT THE STUDIO"),
              ]),
              html.h2([], [
                element.text("Good ideas deserve "),
                html.span([attribute.class("gradient-text")], [
                  element.text("a thoughtful build."),
                ]),
              ]),
            ]),
            html.div([attribute.class("intro-copy")], [
              html.p([], [
                element.text(
                  "Studio Greg helps turn product ideas into reality. From strategy and design 
                  to full-scale product development, we combine human-expertise with AI-powered tools.",
                ),
              ]),
              html.a([attribute.class("text-link"), attribute.href("/About")], [
                element.text("More about the studio"),
                html.span([attribute.aria_hidden(True)], [element.text("→")]),
              ]),
            ]),
          ]),
        ]),
        html.section([attribute.class("projects-section")], [
          html.div([attribute.class("section-shell")], [
            html.div([attribute.class("section-heading")], [
              html.div([], [
                html.p([attribute.class("eyebrow eyebrow-dark")], [
                  element.text("SELECTED PROJECTS"),
                ]),
                html.h2([], [element.text("A few things in the works.")]),
              ]),
              html.a([attribute.class("text-link"), attribute.href("/Projects")], [
                element.text("View all projects"),
                html.span([attribute.aria_hidden(True)], [element.text("→")]),
              ]),
            ]),
            html.div([attribute.class("project-grid")], [
              project_card(
                "01",
                "Inspection Demo",
                "A WASM-powered, offline inspector.",
                "visual-blue",
              ),
              project_card(
                "02",
                "Project 2",
                "A portfolio showcase.",
                "visual-coral",
              ),
            ]),
          ]),
        ]),
        html.section([attribute.class("contact-band")], [
          html.div([attribute.class("section-shell contact-band-inner")], [
            html.div([], [
              html.p([attribute.class("eyebrow")], [
                element.text("HAVE AN IDEA?"),
              ]),
              html.h2([], [element.text("Let’s make it real.")]),
            ]),
            html.a([attribute.class("button button-light"), attribute.href("/Contact")], [
              element.text("Get in touch"),
              html.span([attribute.aria_hidden(True)], [element.text("↗")]),
            ]),
          ]),
        ]),
      ])
    About ->
      html.main([attribute.class("inner-page")], [
        html.section([attribute.class("page-hero")], [
          html.div([attribute.class("section-shell")], [
            html.p([attribute.class("eyebrow eyebrow-dark")], [
              element.text("ABOUT THE STUDIO"),
            ]),
            html.h1([], [
              element.text("Small studio. "),
              html.span([attribute.class("gradient-text")], [
                element.text("Big curiosity."),
              ]),
            ]),
            html.p([attribute.class("page-lead")], [
              element.text(
                "Studio Greg is a home for thoughtful experiments and useful software.",
              ),
            ]),
          ]),
        ]),
        html.section([attribute.class("page-content")], [
          html.div([attribute.class("section-shell narrow-copy")], [
            html.h2([], [element.text("Built around good ideas.")]),
            html.p([], [
              element.text(
                "Studio Greg.",
              ),
            ]),
            html.a([attribute.class("text-link"), attribute.href("/Projects")], [
              element.text("See what’s taking shape"),
              html.span([attribute.aria_hidden(True)], [element.text("→")]),
            ]),
          ]),
        ]),
      ])
    Projects ->
      html.main([attribute.class("inner-page")], [
        html.section([attribute.class("page-hero")], [
          html.div([attribute.class("section-shell")], [
            html.p([attribute.class("eyebrow eyebrow-dark")], [
              element.text("SELECTED WORK"),
            ]),
            html.h1([], [
              element.text("Projects & "),
              html.span([attribute.class("gradient-text")], [
                element.text("experiments."),
              ]),
            ]),
            html.p([attribute.class("page-lead")], [
              element.text("A collection of things built with curiosity."),
            ]),
          ]),
        ]),
        html.section([attribute.class("page-content projects-section")], [
          html.div([attribute.class("section-shell project-grid")], [
            project_card(
              "01",
              "Inspection Demo",
              "A WASM-powered, offline inspector.",
              "visual-blue",
            ),
            project_card(
              "02",
              "Project 2",
              "A portfolio showcase.",
              "visual-coral",
            ),
          ]),
        ]),
      ])
    Contact ->
      html.main([attribute.class("inner-page contact-page")], [
        html.section([attribute.class("page-hero contact-hero")], [
          html.div([attribute.class("section-shell")], [
            html.p([attribute.class("eyebrow eyebrow-dark")], [
              element.text("GET IN TOUCH"),
            ]),
            html.h1([], [
              element.text("Have an idea? "),
              html.span([attribute.class("gradient-text")], [
                element.text("Let’s talk."),
              ]),
            ]),
            html.p([attribute.class("page-lead")], [
              element.text("Let’s connect and make something great together."),
            ]),
            html.a(
              [attribute.class("button"), attribute.href("mailto:hello@greg.studio")],
              [
                element.text("hello@greg.studio"),
                html.span([attribute.aria_hidden(True)], [element.text("↗")]),
              ],
            ),
          ]),
        ]),
      ])
  }
}

// VIEW -----------------------------------------------------------------------
fn view(route: Route) -> element.Element(Msg) {
  html.div([attribute.class("site")], [
    html.link([
      attribute.rel("stylesheet"),
      attribute.href("/site.css"),
    ]),
    site_header(),
    view_route(route),
    site_footer(),
  ])
}
