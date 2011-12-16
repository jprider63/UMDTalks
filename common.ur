style wrapper
style header
style content
style footer
style right
style left
style login
style box

fun template title sidebar =
	title' <- return (case title of
		| None => "UMDTalks"
		| Some t => t ^ " - UMDTalks"
	);
	(*sidebar <- return <xml><div>sidebar</div></xml>;*)
	return <xml>
	<head>
		<title>{[title']}</title>
		<link rel="stylesheet" type="text/css" href="/css/index.css" />
		<link rel="icon" href="/images/favicon.ico" />
	</head>
	<body>
		<div class={wrapper}>
			<div class={header}>
				(*<a link={Umdtalks.index}>*)<img src="/images/reallybigtalkslogo.gif" />(*</a>*)
				<div class={login}>
					<div class={box}>
						<div class={header}>
							Log in
						</div>
					</div>
				</div>
			</div>
			<div class={content}>
				<div class={left}>
					{sidebar}
				</div>
				<div class={right}>
				</div>
			</div>
		</div>
		<div class={footer}>
			About | University of Maryland &copy; 2011
		</div>
	</body>
</xml>



(*
fun template title css sidebar page = return <xml>
	<head>
		<title>{constructTitle title}</title>
		<link rel="stylesheet" type="text/css" href="/css/index.css" />
		{constructCss css}
		<link rel="icon" href="/images/favicon.ico" />
	</head>
	<body>
		<div class={wrapper}>
			<div class={header}>
				<a link={Umdtalks.index ()}><img src="/images/reallybigtalkslogo.gif" /></a>
				<div class={login}>
					<div class={box}>
						<div class={header}>
							Log in
						</div>
					</div>
				</div>
			</div>
			<div class={content}>
				<div class={left}>
					{sidebar}
				</div>
				<div class={right}>
					{page}
				</div>
			</div>
		</div>
		<div class={footer}>
			About | University of Maryland &copy; 2011
		</div>
	</body>
</xml>
*)
