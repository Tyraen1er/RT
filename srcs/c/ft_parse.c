/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_parse.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/06/23 18:33:56 by bmoiroud          #+#    #+#             */
/*   Updated: 2018/01/21 16:28:58 by eferrand         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h"

void	ft_get_scene(char *file, t_parser *p)
{
	char	*line;
	int		ret;
	int		fd;
	int		i;

	fd = open(file, O_RDONLY);
	while ((ret = get_next_line(fd, &line)) && ++p->nb_line)
	{
		if (ret == -1)
			ft_error(1, 0);
		free(line);
	}
	close(fd);
	if ((p->tab = malloc((p->nb_line) * sizeof(char *))) == NULL)
		ft_error(3, 0);
	fd = open(file, O_RDONLY);
	i = 0;
	while ((ret = get_next_line(fd, &p->tab[i])))
	{
		if (ret == -1)
			ft_error(1, 0);
		i++;
	}
	close(fd);
}

void	ft_del_char(char *str, char c1, char c2,char c3)
{
	int		i;
	int		len;
	char	*tmp;

	len = ft_strlen(str);
	i = 0;
	str[0] = ' ';
	str[len - 1] = ' ';
	tmp = ft_strtrim(str);
	if (!ft_comment(tmp))
	{
		while(++i < len)
			if (str[i] == c1 || str[i] == c2 || str[i] == c3)
				str[i] = ' ';
	}
	else
	{
		while(++i < len)
			if (str[i] == ' ')
				str[i] = '-';
	}
	free(tmp);
}

void	ft_clean_tab(t_parser *p)
{
	int		i;
	char	*tmp;

	i = -1;
	if ((p->tab2 = malloc((p->nb_line) * sizeof(char *))) == NULL)
		ft_error(3, 0);
	while (++i < p->nb_line)
	{
		tmp = ft_strtrim(p->tab[i]);
		ft_del_char(tmp, '<', '>', '\t');
		p->tab2[i] = ft_strtrim(tmp);
		free(tmp);
	}
	i = -1;
	while (++i < p->nb_line)
		free(p->tab[i]);
	free(p->tab);
}
	
void	ft_implode(t_parser *p, char *sep, int nb_line)
{
	int		i;
	int		len;

	len = nb_line * ft_strlen(sep);
	i = -1;
	while(++i < nb_line)
		len += ft_strlen(p->tab2[i]);
	i = -1;
	if ((p->data = malloc(len * sizeof(char))) == NULL)
		ft_error(3, 0);
	while(++i < nb_line)
	{
		ft_strcat(p->data, p->tab2[i]);
		if (i + 1 != nb_line)
			ft_strcat(p->data, sep);
	}
	i = -1;
	while (++i < len)
		p->data[i] = ft_tolower(p->data[i]);
	p->data[i] = '\0';
}

void	ft_get_light(char **t, t_data *data, int *i, int *line)
{
	int		j[2];
	int		k;

	k = data->rt.nb_light;
	ft_bzero(&j, sizeof(j));
	while(ft_strcmp(t[++(*i)], "/light") != 0)
	{
		if (ft_strcmp(t[(*i)], "-") == 0)
			*line += 1;
		else if (ft_strcmp(t[(*i)], "position") == 0 && !j[0])
			j[0] = ft_get_coord(t, &data->rt.lights[k].pos, i, line);
		else if (ft_strcmp(t[(*i)], "intensity") == 0 && !j[1])
			j[1] = ft_get_intensity(t, &data->rt.lights[k].intensity, i, line);
		else if (ft_strcmp(t[(*i)], "translation") == 0 && j[0])
			ft_translation(t, &data->rt.lights[k].pos, i, line);
		else if (!ft_comment(t[(*i)]))
			ft_error(2, *line);
	}
	if (j[0] == 0)
	{
		ft_putstr("light position not set, ");
		ft_error(2, *line);
	}
	data->rt.nb_light++;
}

int		ft_get_camera(char **tab, t_eye *eye, int *i, int *line)
{
	int		j[2];

	ft_bzero(&j, sizeof(j));
	while(ft_strcmp(tab[++(*i)], "/camera") != 0)
	{
		if (ft_strcmp(tab[(*i)], "-") == 0)
			*line += 1;
		else if (ft_strcmp(tab[(*i)], "position") == 0 && !j[0])
			j[0] = ft_get_coord(tab, &eye->pos, i, line);
		else if (ft_strcmp(tab[(*i)], "orientation") == 0 && !j[1])
			j[1] = ft_get_rotation(tab, &eye->rot, i, line);
		else if (ft_strcmp(tab[(*i)], "translation") == 0 && j[0])
			ft_translation(tab, &eye->pos, i, line);
		else if (!ft_comment(tab[(*i)]))
			ft_error(2, *line);
	}
	if (j[0] == 0)
	{
		ft_putstr("camera position not set, ");
		ft_error(2, *line);
	}
	return (1);
}

void	ft_get_data(char **tab, t_data *data, int line, int i)
{
	int		j;

	j = 0;
	while (ft_strcmp(tab[++i], "-") == 0 || ft_comment(tab[i]))
		line++;
	if (ft_strcmp(tab[i], "scene") != 0)
		ft_error(2, line);
	while(ft_strcmp(tab[++i], "/scene") != 0)
	{
		if (ft_strcmp(tab[i], "-") == 0)
			line++;
		else if (ft_strcmp(tab[i], "camera") == 0 && j == 0)
			j = ft_get_camera(tab, &data->rt.eye, &i, &line);
		else if (ft_strcmp(tab[i], "light") == 0)
			ft_get_light(tab, data, &i, &line);
		else if (ft_strcmp(tab[i], "cylinder") == 0)
			ft_get_cylinder(tab, data, &i, &line);
		else if (ft_strcmp(tab[i], "sphere") == 0)
			ft_get_sphere(tab, data, &i, &line);
		else if (ft_strcmp(tab[i], "plane") == 0)
			ft_get_plane(tab, data, &i, &line);
		else if (ft_strcmp(tab[i], "cone") == 0)
			ft_get_cone(tab, data, &i, &line);
		else if (ft_strcmp(tab[i], "cube") == 0)
			ft_get_cube(tab, data, &i, &line);
		else if (!ft_comment(tab[i]) || !tab[i + 1])
			ft_error(2, line);
	}
}

void	ft_parse(char *file, t_data *data)
{
	t_parser	p;
	int			i;
	
	i = -1;
	ft_bzero(&p, sizeof(p));
	ft_get_scene(file, &p);
	ft_clean_tab(&p);
	ft_implode(&p, " - ", p.nb_line);
	p.tab = ft_strsplit(p.data, ' ');
	ft_get_data(p.tab, data, data->rt.line, -1);
	ft_default_value(data->rt.objects, &data->rt);
	while (p.tab[++i])
		free(p.tab[i]);
	free(p.tab);
	i = -1;
	while (++i < p.nb_line)
		free(p.tab2[i]);
	free(p.tab2);
	free(p.data);
}
