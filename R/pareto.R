# Force payload delivery to openCPU  #   
pareto <-
function(content, topic, type, totalencounters, theme) {
temp <- gsub('\n', '', fixed = TRUE, content, perl = TRUE)
temp <- gsub("\\s+$", "", temp, perl = TRUE) #Removing trailing whitespace
temp <- gsub(",+$", "", temp, perl = TRUE) #Remove trailing comma if accidentally added by user online
temp <- paste('Mymatrix <- matrix(c(',temp,'), ncol=2, byrow=TRUE,dimnames = list(NULL, c("Reason","count")))')
x<-eval(parse(file = "", n = NULL, text = temp))
if (totalencounters < 0){totalencounters = 0}
totalencounters <- as.numeric(totalencounters)
KUBlue = "#0022B4"
SkyBlue = "#6DC6E7"
par(col.axis="black" ,col.lab=KUBlue ,col.main=KUBlue ,col.sub=KUBlue, col=KUBlue,new = TRUE) #bg=SkyBlue)
if (type=="p" || type=="P")	{
	count <- as.numeric(x [,2])
	names(count) <- x [,1]
	# 2018-04-01 removed col=SkyBlue, 
	pareto.chart(count , ylab = "Frequency", cumperc = seq(0, 100, by = 10), xlab = "", border = KUBlue,main = "")
	if (nchar(topic)> 1)
		{title(topic, cex.main = 1.5, font.main= 2, col.main = KUBlue)}
	#	{mtext(paste("Pareto analysis: ",topic), side=3, line=2, col=KUBlue , cex=3)} #Title moved here 7/19/2014}
	#mtext("Causes of non-conformity sorted by frequency", side=3, line=0.5, col=KUBlue , cex=1.5)
	mtext("Barriers", side=1, line=4, col=KUBlue , cex=1.5)
	if(theme=="KU"){display_logo(x=1.2,y=0.05)}
} else if (type=="b" || type=="B") { # Sorted bar chart
	#plot(c(0, dev.size("px")[1]), c(0, dev.size("px")[2]),axes=F,type="b",xlab="", ylab = "", new = TRUE) # needed if rasterimage later adds anything
	Myframe <- as.data.frame(x)
	Myframe$count<-as.numeric(as.character(Myframe$count))
	totalencounters <- max(Myframe$count, totalencounters)
	ggplot(Myframe, aes(x = reorder(Reason, -count), y = count)) + 
		geom_bar(fill = SkyBlue,stat="identity") + xlab("")+ ylab("Count") + 
		theme(axis.title.x = element_text(size = rel(2), face="bold", angle = 0)) + 
		theme(axis.title.y = element_text(size = rel(2), face="bold", angle = 90)) + 
		theme(plot.background = element_rect(fill = "#FFFFFF")) + ylim(0,totalencounters) +
		#ggtitle(bquote(atop(.(topic), atop(italic('Bar chart (sorted by frequency'), "")))) 
		#ggtitle(expression(atop(topic, atop("Causes of non-conformity sorted by frequency", "")))) + 
		labs(title = topic,  subtitle = "Bar chart (sorted by frequency)") + 
		theme(plot.title = element_text(size = rel(3),face="bold",colour = KUBlue))  +
		theme(axis.text = element_text(colour = KUBlue))+
		theme(axis.title = element_text(colour = KUBlue))
} else { # Cascade
	#plot(c(0, dev.size("px")[1]), c(0, dev.size("px")[2]),axes=F,type="b",xlab="", ylab = "", new = TRUE) # needed if rasterimage later adds anything
	Myframe <- as.data.frame(x)
	Myframe$count<-as.numeric(as.character(Myframe$count))
	totalencounters <- max(Myframe$count, totalencounters)
	#Turn your 'Reason' column into a character vector
	Myframe$Reason <- as.character(Myframe$Reason)
	#Then turn Reason back into a factor with the levels in the correct order
	Myframe$Reason <- factor(Myframe$Reason, levels=unique(Myframe$Reason))
	ggplot(Myframe,  aes(x = Reason, y = count)) + 
		geom_bar(fill = SkyBlue,stat="identity") + xlab("")+ ylab("Count") + 
		theme(axis.title.x = element_text(size = rel(2), face="bold", angle = 0)) + 
		theme(axis.title.y = element_text(size = rel(2), face="bold", angle = 90)) + 
		theme(plot.background = element_rect(fill = "#FFFFFF")) + ylim(0,totalencounters) +
		#ggtitle(bquote(atop(.(topic), atop(italic('Cascade chart'), "")))) 
		labs(title = topic,  subtitle = "Cascade chart") + 
		theme(plot.title = element_text(size = rel(3),face="bold",colour = KUBlue))  +
		theme(axis.text = element_text(colour = KUBlue))+
		theme(axis.title = element_text(colour = KUBlue))
	}
}
