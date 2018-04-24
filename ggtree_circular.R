library("ape")
library("Biostrings")
library("ggplot2")
library("ggtree")
library("phytools")
library("ggrepel")
library("stringr")
library("stringi")
library("abind")
##read in tree file
tree_test <- read.newick("tree.txt")

#use the line to only plot the part of the tree descending from a given node
#subtree <- extract.clade(tree_test,200)

#show node numbers. Used to use FindMRCA for this and just added the bounding taxa, but that was giving me problems?
#it may have been an issue with haveing xlim() with all of my geoms at the end of the script
plot(tree_test)
nodelabels(frame = "none") #add node numbers
#tiplabels(frame = "none") #add tip numbers

##Get a subset of the tree nodes: those that are NOT tips.
q <- ggtree(tree_test)
d <- q$data
d <- d[!d$isTip,]
d <- d[!d$label=="Root",]
sig_labels <- d[as.double(d$label) > 63,]
##Convert the list of node numbers and label values to a dataframe.
sig_labels <- as.data.frame(sig_labels, stringsAsFactors = FALSE)

#Create a color palette which we will draw from to color clades.
palette <- c("#000000", "#009E73","#ffd000","#56B4E9","#e80d3d","#c19205", "#E69F00", "#7D26CD", "#c1b11b", "#CC79A7")

#The order of the nodes here determines which color it is. The first node gets the first non-black color in the pallette
#The second node gets the second non-black color, and so on. Not sure how it knows to not assign black to the first node.
tree_test <- groupClade(tree_test, node=c(219,258,193,251,191,215,166,199,261), group_name = "group")
#tree_test <- groupClade(tree_test, node=c(amphipyrinae_clade,bryophilinae_clade,metoponiinae_clade,condocinae_clade,
#                                          grotellinae_clade,oncocnemidinae_cade,acontiinae_clade,stiriinae_clade,
#                                          noctuinae_clade), group_name = "group")

##used to have "xlim(0, 1)" after the geom_tiplab bit. But that caused 29 additional warnings and a demented tree
wagner <- ggtree(tree_test, layout="circular", branch.length="true",aes(color=group, linetype="solid")) + 
  geom_cladelabel(219, label="Amphipyrinae", fontsize=6, align = TRUE, offset=0.45, offset.text = 0, hjust = -0.2) + 
  geom_cladelabel(199, label="Stiriinae", fontsize=6, align = TRUE, offset=0.45, offset.text = 0.05, hjust = 1.0) +
  geom_cladelabel(193, label="Metoponiinae +\nCydosiinae", fontsize=6, align = TRUE, offset=0.45, offset.text = 0.4, hjust = 0.5) +
  geom_cladelabel(191, label="Grotellinae", fontsize=6, align = TRUE, offset=0.45, offset.text = 0.5, hjust = 0) +
  geom_cladelabel(215, label="Oncocnemidinae", fontsize=6, align = TRUE, offset=0.45, offset.text = 0.4, hjust = 0.5) +
  geom_cladelabel(251, label="Condicinae", fontsize=6, align = TRUE, offset=0.45, offset.text = 0.1, hjust = 0.5) +
  geom_cladelabel(166, label="Acontiinae", fontsize=6, align = TRUE, offset=0.45, offset.text = 0.1, hjust = 1.0) +
  geom_cladelabel(258, label="Bryophilinae", fontsize=6, align = TRUE, offset=0.45, offset.text = 0.07, hjust = 0.6) +
  geom_cladelabel(261, label="Noctuinae", fontsize=6, align = TRUE, offset=0.45, offset.text = 0.07, hjust = 0.5) +
  geom_label(data=sig_labels, size=0.5, fill="white", color="black", aes(label=label), label.padding=unit(0.1, "lines")) +
  scale_colour_manual(values = palette) + 
  geom_tiplab2(size=4) + ggtitle("Amphipyrinae") +
  geom_treescale(x=2,y=1,fontsize=5,linesize=1,offset=1)
  
  #xlim(NA, 5) 

#plot(wagner)

#View plot before saving.
#plot(wagner)

#The xlim() parameter above and the width and height parameters below determine what is in the visible printing area.
ggsave(wagner,file="Amphipyrinae_RAxML_test.pdf", width=20, height=30)
dev.off()

