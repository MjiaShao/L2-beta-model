# data availability:  https://osf.io/muknv/

load('./data/anon_data.RData')

export_names = c("studentindex",
			"depression","anxiety","stress","loneliness",
			"friend.out","interaction.out","e.support.out","inf.support.out","study.out");


gender_string = demographics[,"Gender"];
gender = rep(0,length(gender_string));
gender[gender_string=="Male"] = -1;
gender[gender_string=="Female"] = 1;


index_2019_04 = april2019[, "studentindex"];
data_2019_04 = cbind(index_2019_04, gender[index_2019_04], april2019[, export_names[-1]]);
data_2019_04 = data_2019_04[complete.cases(data_2019_04),];
extraversion_old = demographics[data_2019_04[,1], "extraversion"];

write.table(data_2019_04, file='2019-04.csv', col.names=FALSE, row.names=FALSE, sep=',');
write.table(extraversion_old, file='extraversion_old.csv', col.names=FALSE, row.names=FALSE, sep=',');

# output combined table
index_combined = intersect(sept2019[, "studentindex"], april2020[, "studentindex"]);
data_2019_09 = cbind(index_combined, gender[index_combined], sept2019[index_combined, export_names[-1]]);
data_2020_04 = cbind(index_combined, gender[index_combined], april2020[index_combined, export_names[-1]]);
extraversion_new = demographics[index_combined, "extraversion"];
new_index_combined = complete.cases(cbind(data_2019_09,data_2020_04));
data_2019_09 = data_2019_09[new_index_combined,];
data_2020_04 = data_2020_04[new_index_combined,];
extraversion_new = extraversion_new[new_index_combined];

write.table(data_2019_09, file='./data/combined-2019-09.csv', col.names=FALSE, row.names=FALSE, sep=',');
write.table(data_2020_04, file='./data/combined-2020-04.csv', col.names=FALSE, row.names=FALSE, sep=',');
write.table(extraversion_new, file='extraversion_new.csv', col.names=FALSE, row.names=FALSE, sep=',');

# output separately marginal tables

index_2019_09 = sept2019[, "studentindex"];
data_2019_09 = cbind(index_2019_09, gender[index_2019_09], sept2019[, export_names[-1]]);
data_2019_09 = data_2019_09[complete.cases(data_2019_09),];
extraversion_new = demographics[data_2019_09[,1], "extraversion"];

write.table(data_2019_09, file='./data/marginal-2019-09.csv', col.names=FALSE, row.names=FALSE, sep=',');
write.table(extraversion_new, file='./data/extraversion_new-2019-09.csv', col.names=FALSE, row.names=FALSE, sep=',');


index_2020_04 = april2020[, "studentindex"];
data_2020_04 = cbind(index_2020_04, gender[index_2020_04], april2020[, export_names[-1]]);
data_2020_04 = data_2020_04[complete.cases(data_2020_04),];
extraversion_new = demographics[data_2020_04[,1], "extraversion"];

write.table(data_2020_04, file='./data/marginal-2020-04.csv', col.names=FALSE, row.names=FALSE, sep=',');
write.table(extraversion_new, file='./data/extraversion_new-2020-04.csv', col.names=FALSE, row.names=FALSE, sep=',');
