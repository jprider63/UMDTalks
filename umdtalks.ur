table lists : {
	Id : int,
	Title : string,
	Details : string,
	Kind : string,
	Details_filter : string,
	(*Ex_directory : bool,*)
	Image_id : int,
	Created_at : time,
	Updated_at : time
}
	PRIMARY KEY Id

sequence listSeq

table talks : {
	Id : int,
	Title : string,
	Abstract : string,
	Special_message : string,
	Abstract_filtered : string,
	Start_time : time,
	End_time : time,
	Speaker_name : string,
	Speaker_id : int,
	Series_id : int,
	Venue_id : int,
	Created_at : time,
	Updated_at : time,
	Organiser_id : int,
	Image_id : int
}
	PRIMARY KEY Id

sequence talkSeq

table users : {
	Id : int,
	Email : string,
	Alias : string,
	Password : string,
	Affiliation : string,
	Administrator : int,
	Last_login : time,
	Image_id : int,
	Created_at : time,
	Updated_at : time,
	Session_crumble : int
}
	PRIMARY KEY Id

sequence userSeq

(* Organizations?? or just organizers. *)

style wrapper
style header
style content
style footer
style right
style left
style login
style box
style details
style title
style hdiv
style abstract

cookie userSession : {Username : string, Session_crumb : string}

type user = int * string

fun unimplemented () = return <xml>
	<body>
		Unimplemented
	</body>
</xml>

fun search r = return <xml>
	<body>
		Unimplemented
	</body>
</xml>

fun template title sidebar body = (
	title' <- return (case title of
		| None => "UMDTalks"
		| Some t => t ^ " - UMDTalks"
	);
	return <xml>
		<head>
			<title>{[title']}</title>
			<link rel="stylesheet" type="text/css" href="/css/index.css" />
			<link rel="icon" href="/images/favicon.ico" />
		</head>
		<body>
			<div class={wrapper}>
				<div class={header}>
					<a link={index ()}><img src="/images/reallybigtalkslogo.gif" /></a>
					<div class={login}>
						<div class={box}>
							<div class={header}>
								<a link={signin False}>Log in</a>
							</div>
						</div>
					</div>
				</div>
				<div class={content}>
					<div class={left}>
						{sidebar}
					</div>
					<div class={right}>
						{body}
					</div>
				</div>
			</div>
			<div class={footer}>
				About | University of Maryland &copy; 2011
			</div>
		</body>
	</xml>
)

and index () = (
	search <- searchBox ();
	hasLists <- hasRows (SELECT * FROM lists);
	featLists <- ( case hasLists of
		| True => queryX ( SELECT * FROM lists) (fn r =>
				<xml>
					<div>
						<a link={list r.Lists.Id}>{[r.Lists.Title]}</a>
					</div>
				</xml>
		)
		| False => return <xml>
			There are no featured lists at this time.
		</xml>
	);
	sidebar <- return <xml>
		{search}
		<div class={box}>
			<div class={header}>
				Featured Lists
			</div>
			<div class={content}>
				{featLists}
			</div>
		</div>
	</xml>;
	hasTalks <- hasRows (SELECT * FROM talks);
	featTalks <- ( case hasTalks of
		| True =>
			queryX ( SELECT * FROM talks) (fn r =>
				<xml>
					<div>
						<a link={talk r.Talks.Id}>{[r.Talks.Title]}</a>
					</div>
				</xml>
			)
		| False => return
			<xml>
				There are no featured talks at this time.
			</xml>
		);
	body <- return <xml>
		<div class={box}>
			<div class={header}>
				Featured Talks
			</div>
			<div class={content}>
				{featTalks}
			</div>
		</div>
	</xml>;
	template None sidebar body
)

and list id =
	search <- searchBox ();
	row <- oneOrNoRows (SELECT * FROM lists WHERE lists.Id = {[id]});
	( case row of
		| None =>
			body <- return <xml>
				<div class={box}>
					<div class={header}>
						Sorry!
					</div>
					<div class={content}>
						We could not find the list you were looking for.
					</div>
				</div>
			</xml>;
			template (Some "List not found") search body
		| Some r =>
			sidebar <- return <xml>
				{search}
				<div class={box}>
					<div class={header}>
						Dashboard
					</div>
					<div class={content}>
						Add to list (*<select>
							<option>You have no lists</option>
						</select>*) <br />
						Subscribe to calendar
					</div>
				</div>
				<div class={box}>
					<div class={header}>
						Sublists and Talks
					</div>
					<div class={content}>
						Sublists...
					</div>
				</div>
			</xml>;
			body <- return <xml>
				<div class={box}>
					<div class={header}>
						{[r.Lists.Title]}
					</div>
					<div class={content}>
						Talks in this list
					</div>
				</div>
			</xml>;
			template (Some r.Lists.Title) sidebar body
	)

and talk id =
	search <- searchBox ();
	row <- oneOrNoRows (SELECT * FROM talks WHERE talks.Id = {[id]});
	( case row of
		| None =>
			body <- return <xml>
				<div class={box}>
					<div class={header}>
						Sorry!
					</div>
					<div class={content}>
						We could not find the talk you were looking for.
					</div>
				</div>
			</xml>;
			template (Some "Talk not found") search body
		| Some r => 
			sidebar <- return <xml>
				{search}
				<div class={box}>
					<div class={header}>
						Dashboard
					</div>
					<div class={content}>
						Add to list (*<select>
							<option>You have no lists</option>
						</select>*) <br />
						Download to calendar
					</div>
				</div>
			</xml>;
			body <- return <xml>
				<div class={box}>
					<div class={header}>
						{[r.Talks.Title]}
					</div>
					<div class={content}>
						<div class={title}>Details</div>
						<hr class={hdiv} />
						<ul class={details}>
							<li><img src="/images/user.jpg" /> {[r.Talks.Speaker_name]}</li>
							<li><img src="/images/clock.jpg" /> {[r.Talks.Start_time]}</li>
							<li><img src="/images/house.jpg" /> Todo: the venue </li>
							<li>Organizers: todo!!!</li>
							<li>Series: todo!!!</li>
						</ul>
						<br />
						<div class={title}>Abstract</div>
						<hr class={hdiv} />
						<div class={abstract}>
							{[r.Talks.Abstract]}
						</div>
					</div>
				</div>
			</xml>;
			template (Some r.Talks.Title) sidebar body
	)

(* TODO: change failed to a record, remembers attempted username *)
and signin failed = 
	search <- searchBox ();
	msg <- return ( case failed of
		| False => <xml></xml>
		| True => <xml>Invalid username or password.</xml>
	);
	body <- return <xml>
		<div class={box}>
			<div class={header}>
				Login
			</div>
			<div class={content}>	
				{msg}
				<form>
					<p>Username:<br/><textbox{#Username}/><br/>
					Password:<br/><password{#Password}/><br/>
					<submit value="Login" action={authenticate}/>
					</p>
				</form>
				Register here.
			</div>
		</div>
	</xml>;
	template (Some "Login") search body

and authenticate row =
	r <- oneOrNoRows1 (SELECT users.Id FROM users
											WHERE users.Email={[row.Username]}
											AND users.Password = {[Hash.sha512 (row.Username ^ row.Password)]});
	case r of
		| None => signin False
		| Some r' =>
			let
				val session = {Username = row.Username, Session_crumb = "55"}(*rand num*)
			in
				setCookie userSession {Value = session,
																Expires = None,
																Secure = False};
				return <xml><head/><body></body></xml>
			end

and searchBox () : transaction xbody =
	return <xml>
		<div class={box}>
			<div class={header}>
				Find a Talk
			</div>
			<div class={content}>
				<form>
					<textbox{#Query}/>
					<submit action={search} value="Search" />
				</form>
				<a link={unimplemented ()}>Advanced Search</a>
				<p>
				<a link={index ()}>Upcoming Talks</a><br />
				<a link={index ()}>Recently Added</a>
				</p>
			</div>
		</div>
	</xml>

(*
and featTalks () : xml =
	queryX ( SELECT * FROM talks) (fn r =>
		<xml>
			<div>
				{[r.Talks.Title]}
			</div>
		</xml>
	)
*)
