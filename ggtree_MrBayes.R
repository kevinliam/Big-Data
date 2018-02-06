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
tree_test <- read.nexus("infile.nex.con.tre")
##The "conformat" option in MrBayes wil write tree files readable by things other than FigTree. It writes two trees to the
##file though, so we have to pull out the one with posterior probabilities
tree_test <- tree_test$con_50_majrule


#use the line to only plot the part of the tree descending from a given node
subtree <- extract.clade(tree_test,200)

#show node numbers. Used to use FindMRCA for this and just added the bounding taxa, but that was giving me problems?
#it may have been an issue with haveing xlim() with all of my geoms at the end of the script
plot(tree_test)
nodelabels(frame = "none") #add node numbers
#tiplabels(frame = "none") #add tip numbers

##Get a subset of the tree nodes: those that are NOT tips.
q <- ggtree(tree_test)
d <- q$data
d <- d[!d$isTip,]
d <- d[!d$node=="Root",]
sig_labels <- d[as.double(d$label) > 0.95,]
##Convert the list of node numbers and label values to a dataframe.
sig_labels <- as.data.frame(sig_labels, stringsAsFactors = FALSE)

#Create a color palette which we will draw from to color clades.
palette <- c("#000000", "#009E73","#ffd000","#56B4E9","#e80d3d","#c19205", "#E69F00", "#7D26CD", "#c1b11b", "#CC79A7")

#The order of the nodes here determines which color it is. The first node gets the first non-black color in the pallette
#The second node gets the second non-black color, and so on. Not sure how it knows to not assign black to the first node.
#tree_test <- groupClade(tree_test, node=c(219,258,193,251,191,215,166,199,261), group_name = "group")

bryophilinae_clade <- findMRCA(tree_test, c("RZ523_Stenoloba_futii", "MM04919_Cryphia_raptricula"))
noctuinae_clade <- findMRCA(tree_test, c("MM04752_Noctua_fimbriata", "Nacopa_bistrigata_KLKDNA0014"))
metoponiinae_clade <- findMRCA(tree_test, c("MM00005_Panemeria_tenebrata", "Sexserrata_hampsoni_KLKDNA0170"))
oncocnemidinae_clade <- findMRCA(tree_test, c("Catabenoides_vitrina_KLKDNA0060", "Oxycnemis_gracillinea_KLKDNA0139"))
stiriinae_clade <- findMRCA(tree_test, c("Chrysoecia_scira_KLKDNA0002","Annaphila_diva_KLKDNA0180"))
amphipyrinae_clade <- findMRCA(tree_test, c("Redingtonia_alba_KLKDNA0031","MM01162_Amphipyra_perflua"))
acontiinae_clade <- findMRCA(tree_test, c("Heminocloa_mirabilis_KLKDNA0049","Chamaeclea_pernana_KLKDNA0046"))
noctuinae_clade <- findMRCA(tree_test, c("Hadenela_pergentilis_KLKDNA0155","Nacopa_bistrigata_KLKDNA0014"))
grotellinae_clade <- findMRCA(tree_test, c("Grotellaforma_lactea_KLKDNA0111","Neogrotella_spaldingi_KLKDNA0038"))
condicinae_clade <- findMRCA(tree_test, c("Aleptina_inca_KLKDNA0173","RZ511_Condica_illecta"))
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7", "#7D26CD")

tree_test <- groupClade(tree_test, node=c(amphipyrinae_clade,bryophilinae_clade,metoponiinae_clade,condicinae_clade,
                                         grotellinae_clade,oncocnemidinae_clade,acontiinae_clade,stiriinae_clade,
                                          noctuinae_clade), group_name = "group")



##used to have "xlim(0, 1)" after the geom_tiplab bit. But that caused 29 additional warnings and a demented tree
wagner <- ggtree(tree_test, branch.length="true",aes(color=group, linetype="solid")) + 
  geom_cladelabel(amphipyrinae_clade, label="Amphipyrinae", fontsize=6, align = TRUE, offset=0.5) + 
  geom_cladelabel(stiriinae_clade, label="Stiriinae", fontsize=6, align = TRUE, offset=0.5) +
  geom_cladelabel(metoponiinae_clade, label="Metoponiinae+\nCydosiinae", fontsize=6, align = TRUE, offset=0.5) +
  geom_cladelabel(grotellinae_clade, label="Grotellinae", fontsize=6, align = TRUE, offset=0.5) +
  geom_cladelabel(oncocnemidinae_clade, label="Oncocnemidinae", fontsize=6, align = TRUE, offset=0.5) +
  geom_cladelabel(condicinae_clade, label="Condicinae", fontsize=6, align = TRUE, offset=0.5) +
  geom_cladelabel(acontiinae_clade, label="Acontiinae", fontsize=6, align = TRUE, offset=0.5) +
  geom_cladelabel(bryophilinae_clade, label="Bryophilinae", fontsize=6, align = TRUE, offset=0.5) +
  geom_cladelabel(noctuinae_clade, label="Noctuinae", fontsize=6, align = TRUE, offset=0.5) +
  scale_colour_manual(values = palette) +
  geom_label(data=sig_labels, size=2, fill="white", color="black", aes(label=label), label.padding=unit(0.1, "lines")) + 
  geom_tiplab(size=4) + ggtitle("Amphipyrinae") + xlim(NA, 5) +
  geom_treescale(x=2,y=1,fontsize=5,linesize=1,offset=0.5)
  #geom_nodelab(size=2, fill="white", color="black", aes(label=label), label.padding=unit(0.1, "lines"))

plot(wagner)

#View plot before saving.
#plot(wagner)

#The xlim() parameter above and the width and height parameters below determine what is in the visible printing area.
ggsave(wagner,file="Amphipyrinae_Mr_Bayes.pdf", width=20, height=30)
dev.off()

